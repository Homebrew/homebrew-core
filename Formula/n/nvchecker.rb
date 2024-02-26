class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/0b/e2/1d749d02d1625529571cc01aad4e3e23d834fbe58bfca1a2bf3bb86a8b65/nvchecker-2.13.1.tar.gz"
  sha256 "50594215ebf23f12795886f424b963b3e6fab26407a4f9afc111df4498304ee3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "15676607faa65895cf4e1c47d606d506f60211e35df2361210debd9ba0227f81"
    sha256 cellar: :any,                 arm64_ventura:  "d19bca13d7b1f3fe0d122f9e26c6002bba2fad7a03227b8c3886e8b1a25aaf63"
    sha256 cellar: :any,                 arm64_monterey: "8d4e1467f98657bd8a3237c36da8f7c19d418f2febbae052f133f41521833a37"
    sha256 cellar: :any,                 sonoma:         "ccc85f1647cfc6d288496e9cc22f90909f3660017435fadc925b0f400da0ec85"
    sha256 cellar: :any,                 ventura:        "91e6c93314be29f47dee7d7093aa92c1d630455d89c48b35ba2f239e6a2d628f"
    sha256 cellar: :any,                 monterey:       "9232612732d9a8be1f5fa6a3e22d232f5624f5032a0ea95425f4a7b4db92a51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e51c6de1a0e2d00255788056ef5679294aa41a532b38fb6c0da3109457bc05dc"
  end

  depends_on "jq" => :test
  depends_on "curl"
  depends_on "python@3.12"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
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
