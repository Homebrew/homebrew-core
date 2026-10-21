class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/be/43/e2b9699bb92a8125a24f2052152dfbfa4286285e6ea7aa7a47e8728ed72e/nvchecker-2.22.tar.gz"
  sha256 "7c5d04d55e3faffa2f7e7a81165a2f6b68786f4b185d4e1e2ec7af03a524e784"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "8ebdbfba133809bdc4cff56aeab7fc0d7f1704725893d507eb306a0fb3ba550d"
    sha256 cellar: :any, arm64_tahoe:       "594da078c3449f65cdf95e9f9d4db59c7243e42a808ba455ae261d8be2da400a"
    sha256 cellar: :any, arm64_sequoia:     "787b7cf47e3a4f973bc0d8101ca56d9b8de4ede7e32aca37aa99e77cabd97cc6"
    sha256 cellar: :any, arm64_linux:       "4d3fc5dac03004c53c22d320470e9bd4155ae04c53a09bea085a4a026c1f140b"
    sha256 cellar: :any, x86_64_linux:      "2b8a0c6294a31964bfe75388a0f0c22dac248230b79f14c936176eab679c8abb"
  end

  depends_on "curl"
  depends_on "openssl@4"
  depends_on "python@3.15"

  pypi_packages package_name: "nvchecker[pypi]"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
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
