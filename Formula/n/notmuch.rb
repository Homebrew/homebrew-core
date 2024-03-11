class Notmuch < Formula
  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.38.3.tar.xz"
  sha256 "9af46cc80da58b4301ca2baefcc25a40d112d0315507e632c0f3f0f08328d054"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c48e1b05733714767668ef3ca709dc9af9c251fa2cb81d18b86e28d3e14b8ae1"
    sha256 cellar: :any,                 arm64_ventura:  "3918bf3d786e1c325c1b8ae2256db2eae62658de3d74db3b11be1d7e2f7ebc26"
    sha256 cellar: :any,                 arm64_monterey: "41aabf1ab13a658b79c76ca86e3586c9478d528bd4ec47f38e6c641af7091169"
    sha256 cellar: :any,                 sonoma:         "b695244332bb341dba121c733dd40601a00615e045f1835e4caf104c31415ec0"
    sha256 cellar: :any,                 ventura:        "573fcc8eea0f95a0d74b95c97cc8d7fdb5b979a80a20fa7b80ee1892ba50935b"
    sha256 cellar: :any,                 monterey:       "7ac3901a6a8c992ec80405bcfe5832b29a31ed2e2bbeaeb51b950a9234670cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "758f00b2529ba8bd92621bb147570109c7fb058e8f349461891c7c62618e8f3b"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "sphinx-doc" => :build
  depends_on "cffi"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.12"
  depends_on "talloc"
  depends_on "xapian"

  uses_from_macos "zlib", since: :sierra

  def python3
    "python3.12"
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
