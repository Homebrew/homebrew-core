class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/ba/09/6ca59563371cf5a0839a1bca32f277f00dc737a213b1bfa72e5ec0dfeca6/MapProxy-2.0.2.tar.gz"
  sha256 "1f03b982faec5bda40af3e112edc4d7c29a216a6bce40022eb004923e17d184f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9c4d7a85b9af38a4dc88a45dd540fd56412c050207425d0fa110a1e5050ebe3"
    sha256 cellar: :any,                 arm64_ventura:  "f344f9662a784b3715de987f3125a17ae327b4bc4da486bb697c2c48de32f6f9"
    sha256 cellar: :any,                 arm64_monterey: "59ed1560ce6d242cef0b754403ba61b9623fce3594f3027f4bb41113a0778a7c"
    sha256 cellar: :any,                 sonoma:         "5e724a7d20cc8ff487c8903e2b1c91ed6eb26499f4ee8afb5b5a044abdec8fb8"
    sha256 cellar: :any,                 ventura:        "32e533f8114e6f49006b56800b2226f88928d62d9d1afb0808c02e372e2d5641"
    sha256 cellar: :any,                 monterey:       "e3f98bbf2dd12cbebe6372fc5b260b529e16f811b497ffec4f3355b1dcef6fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26c4cd35b0765e40821998c324b0c31c438e90bf9e4defc915f771c1ad44d29f"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python-certifi"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/7d/84/2b39bbf888c753ea48b40d47511548c77aa03445465c35cc4c4e9649b643/pyproj-3.6.1.tar.gz"
    sha256 "44aa7c704c2b7d8fb3d483bbf75af6cb2350d30a63b144279a09b75fead501bf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
