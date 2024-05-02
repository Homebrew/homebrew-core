class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  # Should be able to remove setuptools from pypi_formula_mappings.json in next release,
  # see: https://github.com/mapproxy/mapproxy/pull/863
  url "https://files.pythonhosted.org/packages/ba/09/6ca59563371cf5a0839a1bca32f277f00dc737a213b1bfa72e5ec0dfeca6/MapProxy-2.0.2.tar.gz"
  sha256 "1f03b982faec5bda40af3e112edc4d7c29a216a6bce40022eb004923e17d184f"
  license "Apache-2.0"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "2c40f3a30623559efe0166eaeb383d7a4d1406158fc2cf03fc1986f2733729cc"
    sha256 cellar: :any,                 arm64_ventura:  "0565fb1caab873569f1bb1fbc2a5eb50936d8cef1047f71de4eb0c692d33c058"
    sha256 cellar: :any,                 arm64_monterey: "150acd2a51bc6573364d0f144a34dfd16d3cb81cf584f8d4dd01ef7b59f63ac9"
    sha256 cellar: :any,                 sonoma:         "cd2f280e07279411860935121fde03a128956595c7a8336a8c1a3e6fc5893dc4"
    sha256 cellar: :any,                 ventura:        "c10f86f71cf3ba06d2fda158946eb2e5a9ece460c3a2599dff71f6fae6ab5cf1"
    sha256 cellar: :any,                 monterey:       "072416e846102529fa74f55f81825cccc3ba3c378db4b3a8f3b218eb3ef4f8d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc6a1b31479e2bed0bd011062b248576e487ab8fafee513596795875e7ec4312"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.12"

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/7d/84/2b39bbf888c753ea48b40d47511548c77aa03445465c35cc4c4e9649b643/pyproj-3.6.1.tar.gz"
    sha256 "44aa7c704c2b7d8fb3d483bbf75af6cb2350d30a63b144279a09b75fead501bf"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
    sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
