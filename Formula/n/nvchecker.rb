class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/0b/e2/1d749d02d1625529571cc01aad4e3e23d834fbe58bfca1a2bf3bb86a8b65/nvchecker-2.13.1.tar.gz"
  sha256 "50594215ebf23f12795886f424b963b3e6fab26407a4f9afc111df4498304ee3"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "720518e3f156801f589c5407090e8fd4547fe91e62c0e161b5c0c3912b570733"
    sha256 cellar: :any,                 arm64_ventura:  "2f348aa830221292afe8fdbebf00f19dce9e52d486ee8d75412afcb14be8a374"
    sha256 cellar: :any,                 arm64_monterey: "663ccc015b0c025732c9da9b89e0d4b408a898156bc6ba9430188f9c78285390"
    sha256 cellar: :any,                 sonoma:         "5a926d76c15d4f707431d505ec32bbe7d33d7885786a9b9d421fae552fbfdb53"
    sha256 cellar: :any,                 ventura:        "d2bc59bf752e88b7de2bfd2c649a812c35aeb1d560db5650fbdd021d05b0cf42"
    sha256 cellar: :any,                 monterey:       "ed5e9d0d47e9820bc4f7910ad4ef69b608065a9689118a6cd2a74acf7a494fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5c21e5484536036f2659e9fc84190eabe28156a3abd8ec5f29f794315b778c9"
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
