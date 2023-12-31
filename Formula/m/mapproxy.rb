class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/63/33/7ca51f30db49eb0bba66d8dffcea4129efb80bf23882f7c0d79d6b819c03/MapProxy-2.0.0.tar.gz"
  sha256 "93073891315dd37f870d5e340cbe0bd24264a56634df44913edd5cefe35cf19d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2fdd033b5092e7be09106e17188eb3029194ce2d2082e25e5a759c37f638ac01"
    sha256 cellar: :any,                 arm64_ventura:  "d1b143b13e8b504c140d3a622f517872929f9a23109a05dacf200814f9623442"
    sha256 cellar: :any,                 arm64_monterey: "15c5463e5b8bd2495a653f6125e885457a3c3c18def6205fe9c5cbfeff68f0ca"
    sha256 cellar: :any,                 sonoma:         "b4d4dc2adc106ae22c3d2d2fe5867cf66764e321aefea24c10f336ac7707277d"
    sha256 cellar: :any,                 ventura:        "26c5fbaed4bffb6230c7d06dd41a5928a047852e44651f8ed576fe5f178d6d95"
    sha256 cellar: :any,                 monterey:       "2d1e7c1adb444149af5abd7bb9ff241d45256059d68a3e16c51408b13c80850e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af8cba20a4697671578487db392a7899101dd25417a70ebff4c4c8dd74d64c8b"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python-certifi"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

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
