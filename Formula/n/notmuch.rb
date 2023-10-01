class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.38.tar.xz"
  sha256 "a17901adbe43f481a6bf53c15a2a20268bc8dc7ad5ccf685a0d17c1456dbaf6e"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd9ce318f993e932a562519a047e9bb8509549c1c7baf23e51894fcf2ccc97dd"
    sha256 cellar: :any,                 arm64_monterey: "d5e2f6c85fe241e503f3d427308476a453bcbbd573253d191a22ef6ac69a997d"
    sha256 cellar: :any,                 arm64_big_sur:  "03b4bd37d3208ee63332ab72a06c9547e59a6ab8b07a87b7a7ba909292a22acb"
    sha256 cellar: :any,                 ventura:        "1142fb66ea9482b075f399fa8214e39ef15b9afec690b5963a33af81e8a0fdbe"
    sha256 cellar: :any,                 monterey:       "0e85ce4e585e7d4fb12853f2e3db4a8203e92849aaf5681e36cfb5134d3c7d04"
    sha256 cellar: :any,                 big_sur:        "d14ee543acd0c0155ea53c33030fffcdbaaad7fb43c1755ff2a0a888c64f4958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5461181e8ec5fda26da1a67f9a08c34dc3d598aa0a1b783824d021ddd7d9f260"
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
