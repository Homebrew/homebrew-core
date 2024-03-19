class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/ba/09/6ca59563371cf5a0839a1bca32f277f00dc737a213b1bfa72e5ec0dfeca6/MapProxy-2.0.2.tar.gz"
  sha256 "1f03b982faec5bda40af3e112edc4d7c29a216a6bce40022eb004923e17d184f"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "82398c857174ec6a22855e591db44faba1ae0270e2ee84457960f0608d8678c2"
    sha256 cellar: :any,                 arm64_ventura:  "06425b98adf84902c1d050ee66c988adff0bb2288868448ef47e69023c441037"
    sha256 cellar: :any,                 arm64_monterey: "57d9aeb9919b4369c31dad5c4e8729587f8cec6881df41538cc8480ba25a0e00"
    sha256 cellar: :any,                 sonoma:         "0b2a3b5cb6b62a0d196a8e14c937d273bfdcd06c972d2a1a439c6a7929b8bd1b"
    sha256 cellar: :any,                 ventura:        "18580838c29f9809de9b1b326d87d62ddeaac7722f2ecc8ad30e21c1d7735fc6"
    sha256 cellar: :any,                 monterey:       "b3b844f92f66b88c2e80ea2678daa725543f7b433066c76ac92ebdfc370d540f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91815dfe504f725458091b08e042a1b3ebf19cb27d42d222c951485a0de43280"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "proj"
  # Should be able to remove python-setuptools dependency in next release,
  # see: https://github.com/mapproxy/mapproxy/pull/863
  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/7d/84/2b39bbf888c753ea48b40d47511548c77aa03445465c35cc4c4e9649b643/pyproj-3.6.1.tar.gz"
    sha256 "44aa7c704c2b7d8fb3d483bbf75af6cb2350d30a63b144279a09b75fead501bf"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
