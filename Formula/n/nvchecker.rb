class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/21/80/76f05a152e7fe5bc6e9351ef5cdb8eee06029e18fabd95b178672512fa03/nvchecker-2.21.tar.gz"
  sha256 "65eb04a74f261e25f62f1678a4b9dbef905c9e3b82777c69d894a1643fbec557"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e9f2bbd7f6007a4a0e1f9ead21c8f7baf2d99ac68a11955623a525fc35788d09"
    sha256 cellar: :any, arm64_sequoia: "bd85e5f1df6d3ec9168b69923e53edfaa30a05d6df30c590b8ead017d2a48f83"
    sha256 cellar: :any, arm64_sonoma:  "74313823b1d7dfc5ffd08ef80f593d16bcc4bc6d2291a40f1e8d52795fa569c4"
    sha256 cellar: :any, sonoma:        "4e217c739678ee33f7094e20ecf369db33c993787ae720db1b8fb11595a176be"
    sha256 cellar: :any, arm64_linux:   "037647532ddd653434320835b649114dca55028acd755b2c2e00c7cfb0c0050b"
    sha256 cellar: :any, x86_64_linux:  "9050cacb59750f426f30c834dc9f28befd4e5dce51b88c6ac606b8c1de1f744c"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.14"

  pypi_packages package_name: "nvchecker[pypi]"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/81/bc/705aa3bc36b99946a128d068e1afd4b6f3eebb36c6b97f551f3d2d740460/pycurl-7.47.0.tar.gz"
    sha256 "5e3cf357939da8d4ceefe3c7f305afcf9b47cba66cfd95e7768ca43b38445e14"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/5e/89/b4a0bcfdf4f71a3dea31379f095929613d7e4528a0996bca6aa964cd0dca/structlog-26.1.0.tar.gz"
    sha256 "f63a716cbd1b1291cf7661de7794b455acfa4c43c5bcf1630e6ad5ddc1adb3b7"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/64/24/95ec527ad67b76d59299e5465b3935d05e4294b7e0290a3924b7487df30b/tornado-6.5.7.tar.gz"
    sha256 "66c513a76cda70d53907bc27cf1447557699c2e95aa48ba27a442ff61c3ddfc2"
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
