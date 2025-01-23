class Notmuch < Formula
  include Language::Python::Shebang

  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.38.3.tar.xz"
  sha256 "9af46cc80da58b4301ca2baefcc25a40d112d0315507e632c0f3f0f08328d054"
  license "GPL-3.0-or-later"
  revision 2
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "cd717cdea34175ce4b3ecb26f15594ed015483ce17e14204864b208afed3cf5e"
    sha256 cellar: :any,                 arm64_sonoma:  "7844df568b86b1b6309c3aa0f6c4cf68ccb8a9b35fc90121b109d05a208b7cac"
    sha256 cellar: :any,                 arm64_ventura: "592e3240392b89a60c68eba4c9bcb7d705c60733a3a8366642336c6369811cc4"
    sha256 cellar: :any,                 sonoma:        "10fa6fbceadb544587d026f3591a1a43c3054cfce290f5d56beda33a201fc98b"
    sha256 cellar: :any,                 ventura:       "3de2605deb58d1854e07fa28ac0730ee6ea82599510297a910d03df7cabbbb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1572f5f82da23d1493d0651c6294c7694f473c36c77d0d08c6f8d535c3ad700b"
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

    ["python", "python-cffi"].each do |subdir|
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./bindings/#{subdir}"
    end
  end

  test do
    (testpath/".notmuch-config").write <<~INI
      [database]
      path=#{testpath}/Mail
    INI
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")

    system python3, "-c", "import notmuch"

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
