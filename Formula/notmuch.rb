class Notmuch < Formula
  include Language::Python::Virtualenv

  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.36.tar.xz"
  sha256 "130231b830fd980efbd2aab12214392b8841f5d2a5a361aa8c79a79a6035ce40"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1ca3510d23a706a7410cd1e01a8be2f7620c28931db37c6c47b417742021fbc8"
    sha256 cellar: :any,                 arm64_big_sur:  "6142a6081fc478c5c55ce553b3c8a901cb653dfddac9e6d79d979a991eacee65"
    sha256 cellar: :any,                 monterey:       "063cf9d0652d8a3fcf1b0d42b04e54448fe56003fac57234c7744f4359db05ff"
    sha256 cellar: :any,                 big_sur:        "312f9e296303bffaf3d238cecf507df26566a1cb705036b8af772d830e357368"
    sha256 cellar: :any,                 catalina:       "c0b035cfd798229a352690627acc6fdca8b30c8555846513346967729f0b828d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcc163570cffea059bf92f45db2fab790d6c7381e17c21ec0ef9058dd6c33f5e"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.9"
  depends_on "talloc"
  depends_on "xapian"

  uses_from_macos "zlib", since: :sierra

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --emacslispdir=#{elisp}
      --emacsetcdir=#{elisp}
      --bashcompletiondir=#{bash_completion}
      --zshcompletiondir=#{zsh_completion}
      --without-ruby
    ]

    site_packages = Language::Python.site_packages("python3")
    ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/site_packages
    ENV.cxx11 if OS.linux?

    system "./configure", *args
    system "make", "V=1", "install"

    elisp.install Dir["emacs/*.el"]
    bash_completion.install "completion/notmuch-completion.bash"

    (prefix/"vim/plugin").install "vim/notmuch.vim"
    (prefix/"vim/doc").install "vim/notmuch.txt"
    (prefix/"vim").install "vim/syntax"

    cd "bindings/python" do
      system "python3", *Language::Python.setup_install_args(prefix)
    end

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install buildpath/"bindings/python-cffi"

    # If installed in non-standard prefixes, such as is the default with
    # Homebrew on Apple Silicon machines, other formulae can fail to locate
    # libnotmuch.dylib due to not checking locations like /opt/homebrew for
    # libraries. This is a bug in notmuch rather than Homebrew; globals.py
    # uses a vanilla CDLL instead of CDLL wrapped with `find_library`
    # which effectively causes the issue.
    #
    # CDLL("libnotmuch.dylib") = OSError: dlopen(libnotmuch.dylib, 6): image not found
    # find_library("libnotmuch") = '/opt/homebrew/lib/libnotmuch.dylib'
    # http://notmuch.198994.n3.nabble.com/macOS-globals-py-issue-td4044216.html
    inreplace prefix/site_packages/"notmuch/globals.py",
              "libnotmuch.{0:s}.dylib",
              opt_lib/"libnotmuch.{0:s}.dylib"
  end

  def caveats
    <<~EOS
      The python CFFI bindings (notmuch2) are not linked into shared site-packages.
      To use them, you may need to update your PYTHONPATH to include the directory
      #{opt_libexec/Language::Python.site_packages(Formula["python@3.9"].opt_bin/"python3")}
    EOS
  end

  test do
    (testpath/".notmuch-config").write "[database]\npath=#{testpath}/Mail"
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")

    python = Formula["python@3.9"].opt_bin/"python3"
    system python, "-c", "import notmuch"
    with_env(PYTHONPATH: libexec/Language::Python.site_packages(python)) do
      system python, "-c", "import notmuch2"
    end
  end
end
