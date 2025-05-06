class Notmuch < Formula
  include Language::Python::Shebang

  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.39.tar.xz"
  sha256 "b88bb02a76c46bad8d313fd2bb4f8e39298b51f66fcbeb304d9f80c3eef704e3"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d82ad567f35dc86cfe9c3238f211849ec7ebd6a64d39728d1be7979885c19a2d"
    sha256 cellar: :any,                 arm64_sonoma:  "ff9e440133a39ffb3a01054b5762e0d5ed7ed14b7aa66db9dc3d586540fc0918"
    sha256 cellar: :any,                 arm64_ventura: "e384a4f762886b8d5e59f6e752574085d2af177c370caab601668eda1725549f"
    sha256 cellar: :any,                 sonoma:        "f2234ee4ad5abe3603aafdd2a79f838c409b5385b4e57cfc9e9e4a794d87d4bc"
    sha256 cellar: :any,                 ventura:       "66dc7a1087e43c91d4a4173a1e8f1f84ec30c9ce852be303440d5f8fc735179d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ba411d8183c7e59331dc5bb6df073d8b2b2cbf17ca94c5d61a382a9a2400816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66b8788cc35e7be17f259b58f807332e5a18bf444578a33e54b3e4f9162f058f"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build

  depends_on "cffi"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.13"
  depends_on "sfsexp"
  depends_on "talloc"
  depends_on "xapian"

  uses_from_macos "zlib", since: :sierra

  on_macos do
    depends_on "gettext"
  end

  def python3
    "python3.13"
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
