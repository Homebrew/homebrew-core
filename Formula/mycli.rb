class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "https://www.mycli.net/"
  url "https://files.pythonhosted.org/packages/d6/e9/e3555839dec9ddbb94e20e5f5b7b633efc603986cffe1113f99048306887/mycli-1.26.1.tar.gz"
  sha256 "8c03035c9b4526dbfa0b0859654e2974a0e77592a9e9b27f40f5a8daae83beb1"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_ventura:  "eae7cfee86bd779cb412d2b494d95aea9717c004be3c957c85daaa0583502d73"
    sha256 cellar: :any,                 arm64_monterey: "6d4ff2e021a465d4735dc95b87eeb04bc9b424e6b72cbd1cbd6fded0fc37cc18"
    sha256 cellar: :any,                 arm64_big_sur:  "77d8a4a81f70352d9be177224634066472d84bfceb98436ee2470beead384fd7"
    sha256 cellar: :any,                 ventura:        "6e854f582c44f7fe32c83f2932cc484ef731f5ba964b99985a1d70111a7b6114"
    sha256 cellar: :any,                 monterey:       "9e0ea674e0bf2cc5e8e7803c06ad544ce5dae27da570ffe2f5ed69b0a04498cb"
    sha256 cellar: :any,                 big_sur:        "e11c1c0e9f018cb161c081e66638aa8de11ca78e56765704a2f76aa3741409cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16a3b4690f361eb12d56d2abb77871014a8d6744dc731aa29959b9d94c4c49ae"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "pygments"
  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/27/01/6aaa4fc415274ac77372b4d259c234b9f5bfc8d78144c3fda1f3019d4690/cli_helpers-2.3.0.tar.gz"
    sha256 "e7174d003a2b58fd3e31a73fbbc45d5aa513de62cbd42d437f78b9658bd5f967"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/a7/51953e73828deef2b58ba1604de9167843ee9cd4185d8aaffcb45dd1932d/cryptography-36.0.2.tar.gz"
    sha256 "70f8f4f7bb2ac9f340655cbac89d68c527af5bb4387522a8413e841e3e6628c9"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/2e/f8/be5c59ff2545362397cbc989f5cd3835326fc4092433d50dfaf21616bc71/importlib_resources-5.10.2.tar.gz"
    sha256 "e4a96c8cc0339647ff9a5e0550d9f276fc5a01ffa276012b58ec108cfd7b8484"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/fb/93/180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9/prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "PyMySQL" do
    url "https://files.pythonhosted.org/packages/60/ea/33b8430115d9b617b713959b21dfd5db1df77425e38efea08d121e83b712/PyMySQL-1.0.2.tar.gz"
    sha256 "816927a350f38d56072aeca5dfb10221fe1dc653745853d30a216637f5d7ad36"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/9f/94/e28696f966305c717710fc93ce297ab64b294dde2d6d56d13b611c444818/sqlglot-11.0.1.tar.gz"
    sha256 "2bdeeaa20c215d48ec28a61057d76568d6a9aeb19af79b0470f7c2e42619aa0c"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/ba/fa/5b7662b04b69f3a34b8867877e4dbf2a37b7f2a5c0bbb5a9eed64efd1ad1/sqlparse-0.4.3.tar.gz"
    sha256 "69ca804846bb114d2ec380e4360a8a340db83f0ccf3afceeb1404df028f57268"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    virtualenv_install_with_resources

    # Click does not support bash version older than 4.4
    generate_completions_from_executable(bin/"mycli", shells:                 [:fish, :zsh],
                                                      shell_parameter_format: :click)
  end

  test do
    system bin/"mycli", "--help"
  end
end
