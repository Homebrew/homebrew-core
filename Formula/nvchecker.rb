class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/71/23/c8839d59b5f7bb64bd8ebc7117c85f18431ca1fc645fce8162762658beca/nvchecker-2.7.tar.gz"
  sha256 "08ce8629025bdfbc3afeceace5319e7dab5f1304f02684aec8f84b8b416e1876"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad940b8747a66ae199e29ee5dbc78343393e70829325dc93c04a71ce02e3a57c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "888b6250a3a6a0e9d22253c580d79b686fe0bd62b8011b03e13f0d9551e100b4"
    sha256 cellar: :any_skip_relocation, monterey:       "c950f0601b938cd1c2b32675f7cc2a5a072ef1c5f78e4c721340467acf638984"
    sha256 cellar: :any_skip_relocation, big_sur:        "579a8ac1b36136aa893fbc9a65941b5498a1d22e4eddfd873e919565224f7157"
    sha256 cellar: :any_skip_relocation, catalina:       "ab42194df2f9ca3483b953bb64a129c515f1c1730cf24bfa7500b4571947d15a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec281e84b81957e45bf5e2db1cd3fddfd26c7412e24088d12a28c6d8593497d8"
  end

  depends_on "jq" => [:test]
  depends_on "python@3.10"

  uses_from_macos "curl"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/09/ca/0b6da1d0f391acb8991ac6fdf8823ed9cf4c19680d4f378ab1727f90bd5c/pycurl-7.45.1.tar.gz"
    sha256 "a863ad18ff478f5545924057887cdae422e1b2746e41674615f687498ea5b88a"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/ea/77/e38019e698b0c0134f903ab40e87f0975813ca7f74dad287272788134f03/structlog-21.5.0.tar.gz"
    sha256 "68c4c29c003714fe86834f347cb107452847ba52414390a7ee583472bde00fc9"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/cf/44/cc9590db23758ee7906d40cacff06c02a21c2a6166602e095a56cbf2f6f6/tornado-6.1.tar.gz"
    sha256 "33c6e81d7bd55b468d2e793517c909b139960b6c790a60b7991b9b6b76fb9791"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "github"
      github = "lilydjwg/nvchecker"
      use_max_tag = true
      prefix = "v"
    EOS

    out = shell_output("#{bin}/nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end
