class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.37.tar.xz"
  sha256 "0e766df28b78bf4eb8235626ab1f52f04f1e366649325a8ce8d3c908602786f6"
  license "GPL-3.0-or-later"
  revision 3
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cb53342a8f60711edd31588bece2fe0790bae0881ba17d12c6e742cfd9e89cdc"
    sha256 cellar: :any,                 arm64_monterey: "2e5dd617b799c2cb51d2fd27ca3f79cbd393721cbb516ad9c69498fcd706ffaa"
    sha256 cellar: :any,                 arm64_big_sur:  "e806bc40eea77aeb9f22130c2d8a1cc0fc098aedf1b164e65fcaad980eaefaff"
    sha256 cellar: :any,                 ventura:        "c291a7902b95702590ce2b08f0896576f2bfd575dd4244f56c3c3d1042c34fe3"
    sha256 cellar: :any,                 monterey:       "84dd871357b3fc0e73e3510ccfad6680f9fd93f299acd0d3b4a4ea2c55a8f27f"
    sha256 cellar: :any,                 big_sur:        "bf3cadada32b92064ebfa8e9bd7f227abab5bda1cc6250d126dcca1381027173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56bd2a93e75ba5e2d34b0ccc613c0dbe3f1bc62e9e8ba5065c891e24e9413107"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "cffi"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.11"
  depends_on "talloc"
  depends_on "xapian"

  uses_from_macos "zlib", since: :sierra

  def python3
    "python3.11"
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

    elisp.install Pathname.glob("emacs/*.el")
    bash_completion.install "completion/notmuch-completion.bash"

    (prefix/"vim/plugin").install "vim/notmuch.vim"
    (prefix/"vim/doc").install "vim/notmuch.txt"
    (prefix/"vim").install "vim/syntax"

    ["python", "python-cffi"].each do |subdir|
      system python3, "-m", "pip", "install", *std_pip_args, "./bindings/#{subdir}"
    end
  end

  test do
    (testpath/".notmuch-config").write <<~EOS
      [database]
      path=#{testpath}/Mail
    EOS
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")

    system python3, "-c", "import notmuch"

    system python3, "-c", <<~PYTHON
      import notmuch2
      db = notmuch2.Database(mode=notmuch2.Database.MODE.READ_ONLY)
      assert str(db.path) == '#{testpath}/Mail', 'Wrong db.path!'
      db.close()
    PYTHON
  end
end
