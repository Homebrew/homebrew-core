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
    sha256 cellar: :any,                 arm64_monterey: "033f8194e3012df7af907c92dce400b622e37dd01553b570b688804902ac9ece"
    sha256 cellar: :any,                 arm64_big_sur:  "941cb39c18b3eca969dac2e3d639330cf59d06eb1d57a2c906d0cdf7364d12a2"
    sha256 cellar: :any,                 monterey:       "0869abd8e2652d1bec38753910e14493335c5341ea1de2dbeae58b9f7126b7ec"
    sha256 cellar: :any,                 big_sur:        "1e4c00ec1ac42f7f87aeab54c1701fc1565fa25e262abe2a35c5c25393bc4592"
    sha256 cellar: :any,                 catalina:       "21b8fb998d0d725869ceb48107fa5ea2c964af8a5849eb2c83d9761277846778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3e4c34716845a8371803a77a01a6159dc9bf576142ed25552a9abe25431917b"
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
