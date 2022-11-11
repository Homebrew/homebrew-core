class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/db/98/d8805c5434d4b636cd2b71d613148b2096d36ded5b6f6ba0e7325d03ba2b/MapProxy-1.15.1.tar.gz"
  sha256 "4952990cb1fc21f74d0f4fc1163fe5aeaa7b04d6a7a73923b93c6548c1a3ba26"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "db72a46652793ed7f641e608855211c104dc4163c64d8fa2aa2679e30d9a2a63"
    sha256 cellar: :any,                 arm64_monterey: "1f7f76b227e635e78179db1da2ec4f2c57dd8a752bafcc65d33c5282c399c9fd"
    sha256 cellar: :any,                 arm64_big_sur:  "e894d1e3e137da8dc77cceda200b2d832fde3db82d579785ac63b5b7098c223c"
    sha256 cellar: :any,                 monterey:       "50214110fd2799c5915f9eb3a9caa2159d4e8f3688c2cab1d002ce7e81e49927"
    sha256 cellar: :any,                 big_sur:        "9afb0314606e933b86395c1f38b69e8d9c30e28fe7e266f50d4a3f7d27844c35"
    sha256 cellar: :any,                 catalina:       "8a8f9bc035f068eacc11e81546e88897c239e66c170858801c98a0e2b56fa592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c5f11427dadc77c24a18fe1a5ff550107ee0ee940975aeee8ecd75b5f468839"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/aa/d5/492f4284cb88f912d329e8430917ac2f5427833c31843a712cf9dc703471/pyproj-3.4.0.tar.gz"
    sha256 "a708445927ace9857f52c3ba67d2915da7b41a8fdcd9b8f99a4c9ed60a75eb33"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
