class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/7b/60/fd880c869c6a03768fcfe44168d7667f036e2499c8816dd106440e201332/nvchecker-2.15.1.tar.gz"
  sha256 "a2e2b0a8dd4545e83e0032e8d4a4d586c08e2d8378a61b637b45fdd4556f1167"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "344b6b08f4321b14758c0b807e3e9131874917920a312e77dfe054bf673c5936"
    sha256 cellar: :any,                 arm64_ventura:  "4712d70f895b55bce21491792a2f7e5dfe4946faa590ae95e34f9b4524c3cd92"
    sha256 cellar: :any,                 arm64_monterey: "91e4397ebcc8882e8d4e299813998cd7110c690ded807b215637cba52e0e41e8"
    sha256 cellar: :any,                 sonoma:         "3801d03c3f34cf1c70ce19c8dcb90eaee17924d23c73ddb31b400b69ad48682f"
    sha256 cellar: :any,                 ventura:        "5a4b8c21fc8540743febf8d913004c7207fa448d2decd157ecc868b7c8c0657e"
    sha256 cellar: :any,                 monterey:       "32808fe993c10a4ab7de50ee0c981890134d28bb2fdd2f911682634126b9eb03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d00485828972efa74808b34d98219060fc93c96b16000c0b1a5f0f1884c4eef4"
  end

  depends_on "jq" => :test
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/c9/5a/e68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72/pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/87/87/9b237eda856dc3e72f2485e884f59fe0ee8be49aa2ce8eff3a425c388766/structlog-24.2.0.tar.gz"
    sha256 "0e3fe74924a6d8857d3f612739efb94c72a7417d7c7c008d12276bca3b5bf13b"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/ee/66/398ac7167f1c7835406888a386f6d0d26ee5dbf197d8a571300be57662d3/tornado-6.4.1.tar.gz"
    sha256 "92d3ab53183d8c50f8204a51e6f91d18a15d5ef261e84d452800d4ff6fc504e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    EOS

    out = shell_output("#{bin}/nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end
