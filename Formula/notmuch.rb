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
    sha256 cellar: :any,                 arm64_ventura:  "ed024d3539758c36f8cb6a97774ecaa52ef04d631f9af13eda3746060923d220"
    sha256 cellar: :any,                 arm64_monterey: "8df2e487a5c64d1eebdf18ba66171c9f3037550b2dcbb049bf62eb6f0a41cc7b"
    sha256 cellar: :any,                 arm64_big_sur:  "dea84eba81f2265c25fd9e4186fbd24175d0c00125ff0e4c5a783d0c627be3bd"
    sha256 cellar: :any,                 ventura:        "fef920bcbd5fe54a3211110c18287b9622a328cdc2ede30a9307656620ccb1d0"
    sha256 cellar: :any,                 monterey:       "4815aac84a42dc1b40dcd7fced6295e764e77d57f1b270d87466a6addae1a6cb"
    sha256 cellar: :any,                 big_sur:        "7b26d6498972ee90cfebeda76047001fe8194f5f44bf8fe6425059723f17706d"
    sha256 cellar: :any,                 catalina:       "c5b74dd48985c55a7bb92b9b3eb1140ffc10b053a50ba7205da6be4913fd65cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f87c70a3e47b6422b5dc2abf802ace4115e9a52eeb20926d3017c3513bb1767"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "cffi"
  depends_on "glib"
  depends_on "gmime"
  depends_on "pycparser"
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
      cd "bindings/#{subdir}" do
        system python3, *Language::Python.setup_install_args(prefix, python3)
      end
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

    (testpath/"notmuch2-test.py").write <<~PYTHON
      import notmuch2
      db = notmuch2.Database(mode=notmuch2.Database.MODE.READ_ONLY)
      print(db.path)
      db.close()
    PYTHON
    assert_match "#{testpath}/Mail", shell_output("#{python3} notmuch2-test.py")
  end
end
