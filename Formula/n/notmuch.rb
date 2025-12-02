class Notmuch < Formula
  include Language::Python::Shebang

  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.39.tar.xz"
  sha256 "b88bb02a76c46bad8d313fd2bb4f8e39298b51f66fcbeb304d9f80c3eef704e3"
  license "GPL-3.0-or-later"
  revision 2
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ce6d2376e4f4c259353d1e171048c85bf531f17ed15cca6548b98bc00d6c7be"
    sha256 cellar: :any,                 arm64_sequoia: "fd95898d652007c95dbf52a842ce3c5d085abd1dbe871e1bd760bb955a669c5c"
    sha256 cellar: :any,                 arm64_sonoma:  "37224d35b365b81c30a7eea3d35285feb7544a15b388aeb8c724f493713b3abd"
    sha256 cellar: :any,                 sonoma:        "7140d21693d5e91d6115cdd29a103e1c607b2346394b0a65a60755244bddb900"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22b62f435648548fdd06dfc317f0c0df25490373b7aafb1a98daba2b4f7149c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6911d5d204d2568fc22d8b8e7535fee3479a1dbada68a1f4b5fd92eddc442b3"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build

  depends_on "cffi"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.14"
  depends_on "sfsexp"
  depends_on "talloc"
  depends_on "xapian"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def python3
    "python3.14"
  end

  def install
    ENV.cxx11 if OS.linux?
    site_packages = Language::Python.site_packages(python3)
    with_env(PYTHONPATH: Formula["sphinx-doc"].opt_libexec/site_packages) do
      system "./configure", "--prefix=#{prefix}",
                            "--mandir=#{man}",
                            "--emacslispdir=#{elisp}",
                            "--emacsetcdir=#{elisp}",
                            "--bashcompletiondir=#{bash_completion}",
                            "--zshcompletiondir=#{zsh_completion}",
                            "--without-ruby"
      system "make", "V=1", "install"
    end
    bin.install "notmuch-git"
    rewrite_shebang detected_python_shebang, bin/"notmuch-git"

    elisp.install Pathname.glob("emacs/*.el")
    bash_completion.install "completion/notmuch-completion.bash" => "notmuch"

    (prefix/"vim/plugin").install "vim/notmuch.vim"
    (prefix/"vim/doc").install "vim/notmuch.txt"
    (prefix/"vim").install "vim/syntax"

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./bindings/python-cffi"
  end

  test do
    (testpath/".notmuch-config").write <<~INI
      [database]
      path=#{testpath}/Mail
    INI
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")

    system python3, "-c", <<~PYTHON
      import notmuch2
      db = notmuch2.Database(mode=notmuch2.Database.MODE.READ_ONLY)
      assert str(db.path) == '#{testpath}/Mail', 'Wrong db.path!'
      db.close()
    PYTHON
    system bin/"notmuch-git", "-C", "#{testpath}/git", "init"
    assert_path_exists testpath/"git"
  end
end
