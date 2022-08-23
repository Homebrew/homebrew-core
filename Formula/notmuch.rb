class Notmuch < Formula
  include Language::Python::Virtualenv

  desc "Thread-based email index, search, and tagging"
  homepage "https://notmuchmail.org/"
  url "https://notmuchmail.org/releases/notmuch-0.37.tar.xz"
  sha256 "0e766df28b78bf4eb8235626ab1f52f04f1e366649325a8ce8d3c908602786f6"
  license "GPL-3.0-or-later"
  head "https://git.notmuchmail.org/git/notmuch", using: :git, branch: "master"

  livecheck do
    url "https://notmuchmail.org/releases/"
    regex(/href=.*?notmuch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bda7e72a5efdd06041eeb5cd38c0a01a265337b411dd883c4cf1cbde255d91d5"
    sha256 cellar: :any,                 arm64_big_sur:  "55af730a8c2ae56b2c46e61c4a81a5a95166d7143c1ea8b03281489468d60750"
    sha256 cellar: :any,                 monterey:       "d335d7bb29f66e584f71144651a98f064cb9f4d4d88012730c112368de5ab03e"
    sha256 cellar: :any,                 big_sur:        "71f244044e3f517088fb353c07a0c1b10e1f165e64a8b9b0a042c11fe0a9713c"
    sha256 cellar: :any,                 catalina:       "a16751a7ca5e21af3642a60c6054132f097341d7c8d5d9ad047b9291f05eed31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f4f569c921bad4f0ae3e8f0cb468ed4ab22d6b56f0088b55eefa7ae78f79d52"
  end

  depends_on "doxygen" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "gmime"
  depends_on "python@3.10"
  depends_on "talloc"
  depends_on "xapian"

  uses_from_macos "zlib", since: :sierra

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  def install
    ENV.cxx11 if OS.linux?
    site_packages = Language::Python.site_packages("python3")
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
      #{opt_libexec/Language::Python.site_packages(Formula["python@3.10"].opt_bin/"python3")}
    EOS
  end

  test do
    (testpath/".notmuch-config").write <<~EOS
      [database]
      path=#{testpath}/Mail
    EOS
    (testpath/"Mail").mkpath
    assert_match "0 total", shell_output("#{bin}/notmuch new")

    python = Formula["python@3.10"].opt_bin/"python3"
    system python, "-c", "import notmuch"
    with_env(PYTHONPATH: libexec/Language::Python.site_packages(python)) do
      system python, "-c", "import notmuch2"
    end
  end
end
