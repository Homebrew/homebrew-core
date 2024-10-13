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
    sha256 cellar: :any,                 arm64_sequoia:  "26f075815a3971c6e6fd67895e1e9009f2828c08469b3ec2a32fe365db2f0343"
    sha256 cellar: :any,                 arm64_sonoma:   "dc0c9e64e45666c7b504edd124623723793d558f9b92841318cfb57e1905a2bc"
    sha256 cellar: :any,                 arm64_ventura:  "5866c39776242b60bdffeae0cd8a8e72f4b436fff63eb3fcf2b33d7be69c32a4"
    sha256 cellar: :any,                 arm64_monterey: "8040db968c5da6d96e90ccd2c1044f1c8eb0dfd0a6c5edc864f33105d31f4894"
    sha256 cellar: :any,                 sonoma:         "f1017f9efe6fc4487a494f9838dd6ff4177a351ee914fa9845cd3be72132898d"
    sha256 cellar: :any,                 ventura:        "2f10a85b0c2155e200abc0a4592f6285aaa8b754b20fb3b4cc90ac25a94731ab"
    sha256 cellar: :any,                 monterey:       "57d086ced8e109e947cdabbaeb81ef9a50b079630b2b73eda20c912d314bb90f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3db984b392cccc361c5ffe324b79ea2e49631c1a468b1ab088bd01162dbcb66"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  depends_on "cffi"
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.12"
  depends_on "talloc"
  depends_on "xapian"

  uses_from_macos "zlib", since: :sierra

  on_macos do
    depends_on "gettext"
  end

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
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./bindings/#{subdir}"
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
