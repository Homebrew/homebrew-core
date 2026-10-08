class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/be/43/e2b9699bb92a8125a24f2052152dfbfa4286285e6ea7aa7a47e8728ed72e/nvchecker-2.22.tar.gz"
  sha256 "7c5d04d55e3faffa2f7e7a81165a2f6b68786f4b185d4e1e2ec7af03a524e784"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "72c03e782af3e09ebedc02d98fb53db5f4ec8b315577f3160bc780990abd4331"
    sha256 cellar: :any, arm64_tahoe:       "001d5fa744d2af67339008a2be1ee96c169b263da6ef028dfbcc1d972982c14f"
    sha256 cellar: :any, arm64_sequoia:     "df02e04d94a54f04842b436b2285e69733ecafcffb2d87d736c29f1de120aadd"
    sha256 cellar: :any, arm64_linux:       "63c6a701b6296528c58f9f30cc2adaed9cff0610c61abcc29547c0259b62abbb"
    sha256 cellar: :any, x86_64_linux:      "d990d30f08325b8f81621e70ec5d9d9b5b7dad1615351b733e852c95399917e9"
  end

  depends_on "curl"
  depends_on "openssl@4"
  depends_on "python@3.14"

  pypi_packages package_name: "nvchecker[pypi]"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/17/c8/721b3855fe457da514fe249247d404b9b39c5d16532278f70ebaa6acf18b/platformdirs-4.12.2.tar.gz"
    sha256 "eab5f70271a490ef74618bb314fbb86e3c7e82fa3b9c922c2ea0e0a1a155d329"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/fe/62/5851dbbaba9b8ba69019ee74213f1c31b0b2b7ba643ad48e9407638b0dea/pycurl-7.48.0.tar.gz"
    sha256 "b70961a76c412cd34f9cc2c9558e63f89fb37045c59eee396c585b52973be280"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/5e/89/b4a0bcfdf4f71a3dea31379f095929613d7e4528a0996bca6aa964cd0dca/structlog-26.1.0.tar.gz"
    sha256 "f63a716cbd1b1291cf7661de7794b455acfa4c43c5bcf1630e6ad5ddc1adb3b7"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/06/61/53d562a57b28c08eda40b258c0f975e360541943ad7c7bef897a40caafda/tornado-6.5.10.tar.gz"
    sha256 "a6b1ccd08c04b4a06fb5aeb381be99de5ad1e5375c1785e31d78c880feb57687"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~TOML
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    TOML

    output = JSON.parse(shell_output("#{bin}/nvchecker -c #{file} --logger=json"))
    assert_equal version.to_s, output["version"]
  end
end
