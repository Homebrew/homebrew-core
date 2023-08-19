class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/b0/ab/0d6b1a95bc554d35763451f17315d61c763fb4316bdc9a47129353b90e65/coconut-3.0.3.tar.gz"
  sha256 "700309695ee247947a3b9b451603dcc36a244d307d04be1841a87afb145810b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "632c51ca99a56bd2df9897c209407667ceb9329738358d11175b0db309eb6b31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cf3176715fcf41cd445ea3e6ee5282a837da9d1d6f0ccfac173e95b3930d856"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09ca958748b13f389c0eba7f3680a0665a8e8677f41f441fb227cba9a3b253d2"
    sha256 cellar: :any_skip_relocation, ventura:        "e0eb0a04ae4a8023ed2e04b5a81b5a607850842f4712fbdc14fe4733ba5b864f"
    sha256 cellar: :any_skip_relocation, monterey:       "690c3217fe38be2d19779b08a03ca00bb1ac205b3f263de9269a6cfec884d011"
    sha256 cellar: :any_skip_relocation, big_sur:        "17b29d5cc866cc727d03ea376bdfe5480f589eb39b25cc08558a880c16bf71ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef4859b5baadfb7f45687ec69b7a0465d449273b995ed223151f52967c55da65"
  end

  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "cpyparsing" do
    url "https://files.pythonhosted.org/packages/8c/51/548830735273fbc91cdd0d583136577204089ea2ecf6ea2e85d135cf5230/cPyparsing-2.4.7.2.2.1.tar.gz"
    sha256 "4eb32b96ca130177bed9fde8e3e3ad8b6fb2dd95de60698a1adf5d53c5c5b953"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end
