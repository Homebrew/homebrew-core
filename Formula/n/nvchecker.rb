class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/2b/ad/f48d2bcce3acfbfd2ac78d10fa1448598b46f98f7e84718810b5f2d9a8c6/nvchecker-2.14.1.tar.gz"
  sha256 "7a2992e6d5cab1907a16d079281a175cffa355b5d3c97fc782fa92f2fa3cdaca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5ca0abe68ece2ec1b65889b0d13d29d69ee267258854a5dd794de85ec32f1b5e"
    sha256 cellar: :any,                 arm64_ventura:  "310c5089b9b19a0c42692f64b7f080d45a3de2902c372e078f0db167e3622acc"
    sha256 cellar: :any,                 arm64_monterey: "213ae682f520c5ece21eda8498cfe814a789b389536c64f6d2cc063fe847fe26"
    sha256 cellar: :any,                 sonoma:         "f879f0699331cf1f629bbdabccd2985fc319b0ad30bdfd8223fa084ea3aa454c"
    sha256 cellar: :any,                 ventura:        "7287f329c7c6a3117266e30d8aa521b90da9c8675de7be45663dc8c0c07b84cd"
    sha256 cellar: :any,                 monterey:       "746322251f84185af8a733b9c7afb87d36d520fae1769f62df46f3cc6c85f605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7beb766ebd854b2ab40348d982231bbcad85b9742eee4bbfa08de6b8ab9347d7"
  end

  depends_on "jq" => :test
  depends_on "curl"
  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/c9/5a/e68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72/pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/d1/ac/87aedb7a9ba52f645b9d29a7f48bb12a5c6b7e204b8137549fbe4754b563/structlog-24.1.0.tar.gz"
    sha256 "41a09886e4d55df25bdcb9b5c9674bccfab723ff43e0a86a1b7b236be8e57b16"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/bd/a2/ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2/tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
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
