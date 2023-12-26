class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/a8/74/77bf12d3dd32b764692a71d4200f03429c41eee2e8a9225d344d91c03aff/jsonschema-4.20.0.tar.gz"
  sha256 "4f614fd46d8d61258610998997743ec5492a648b33cf478c1ddc23ed4598a5fa"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5489d6d6336f67ab7b34573bd711898d2342fec5a0ebe9177712b13e2ad837e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4497ebb5664dd3b2b87a8b47a66ae796cf317032dd833e8f79488064b3b9c0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b218d0b5f2b42e17c13710955b8099021ef302453fb6f6e01bdc9c4c5002307c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6584b6fed9ac39d34eb7128dc34b624fe7a5c8bd463d20ddca421c327d5b455d"
    sha256 cellar: :any_skip_relocation, sonoma:         "08455d10cd6f85e8bd4dbfa75736839b70028cc1657f6ac73f8bd6c1f2ee89eb"
    sha256 cellar: :any_skip_relocation, ventura:        "ca12521a58d52cb0880a2c2a170ec74738f43738c2b11889c4ec1253f6e6d354"
    sha256 cellar: :any_skip_relocation, monterey:       "22ef6546b03378994e3cee49bfc7f3f0127d13b88a938fba53e31d8987620ad3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0aac0cf2e568bc02885ca1448ea6969109d57bf482b156c26d71b7f8c9b9ac29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5d9adbaab5f963722b4da057ae1524bb48c5c7d5f4f1cf2a214c969d6160598"
  end

  deprecate! date: "2023-01-20", because: "cli is deprecated, and will be removed"

  depends_on "python@3.11"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/96/71/0aabc36753b7f4ad18cbc3c97dea9d6a4f204cbba7b8e9804313366e1c8f/referencing-0.32.0.tar.gz"
    sha256 "689e64fe121843dcfd57b71933318ef1f91188ffb45367332700a86ac8fd6161"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/a9/27/92d18887228969196cd80943e3fb94520925462aa660fb491e4e2da93e56/rpds_py-0.15.2.tar.gz"
    sha256 "373b76eeb79e8c14f6d82cb1d4d5293f9e4059baec6c1b16dca7ad13b6131b39"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~EOS
      {
      	"name" : "Eggs",
      	"price" : 34.99
      }
    EOS

    (testpath/"test.schema").write <<~EOS
      {
        "type": "object",
        "properties": {
            "price": {"type": "number"},
            "name": {"type": "string"}
        }
      }
    EOS

    out = shell_output("#{bin}/jsonschema --output pretty --instance #{testpath}/test.json #{testpath}/test.schema")
    assert_match "SUCCESS", out
  end
end
