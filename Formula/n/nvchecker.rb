class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/be/43/e2b9699bb92a8125a24f2052152dfbfa4286285e6ea7aa7a47e8728ed72e/nvchecker-2.22.tar.gz"
  sha256 "7c5d04d55e3faffa2f7e7a81165a2f6b68786f4b185d4e1e2ec7af03a524e784"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "519c6daabcf15100e7be0992071944b3ba58c836f3849996bb9be8f343d2771b"
    sha256 cellar: :any, arm64_tahoe:       "0addcacb0e328b872c8d32f789dbb5e0bde0ee0526d27daaf4e10aa96049c09a"
    sha256 cellar: :any, arm64_sequoia:     "106aa316d6a0948a380fb34a315699bb298fb448ae1df3ad020faca4437763c1"
    sha256 cellar: :any, arm64_linux:       "0ca70236db2035937984756f8227c46538fa69524562333655b2bdf136fbcef9"
    sha256 cellar: :any, x86_64_linux:      "c45a3b0896b4a4fcebc215d38e5495c83357fd967ea652640e8726a7acf48633"
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
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/a6/b3/93b9b8b4ed45f4700b3f9fc40b5daf189e0badd71d0839a6ad09cefa2245/pycurl-7.49.0.tar.gz"
    sha256 "d4327da9dea72768f942f831bbaa5a64adca4d7c89f3141da7a833d3c600ab90"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/5e/89/b4a0bcfdf4f71a3dea31379f095929613d7e4528a0996bca6aa964cd0dca/structlog-26.1.0.tar.gz"
    sha256 "f63a716cbd1b1291cf7661de7794b455acfa4c43c5bcf1630e6ad5ddc1adb3b7"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/64/2b/8ff2b41620cbba0eeb0862fed21dcaa5a2ad36c6dd9bb465f9ff7a147be2/tornado-6.6.1.tar.gz"
    sha256 "28e6311402af59c8b02e3fa0f5e7d8eb465b25081381803b127d97e6a4395d5a"
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
