class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/mongodb-labs/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/c9/3b/6e579eb7aae04e95c194e6ca57666bc4d1cd0dff4f81de0b3f7e663222b5/mongo_orchestration-0.11.2.tar.gz"
  sha256 "6f0996e5bb072e8dbd0009289b31debb88a647f562c486cfc2c73583ab059993"
  license "Apache-2.0"
  revision 2
  head "https://github.com/mongodb-labs/mongo-orchestration.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84d32d45bd081cff62c2cef2caf17c4bd08e5e1b606fcd45855c33c7d80cc547"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22264bf684f690f3f940361386976d1661f251dbc855b947bf50838f265f9209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad28a560526e26b717dec40fee3d8f324fb6033574d99195075d8a59c622af7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcc64537c9412d4bd956c51ae7a4635fa46cfa3860d2dae2fc9c39292a6bf608"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9baf99e15c919df0025e4a97285a7241b64c85d57630e82852cc42575b269178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "301fcab1e9cea5923d0183c09c92b2bbcbffc1002c2992e34dc210bf7ea220be"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/7a/71/cca6167c06d00c81375fd668719df245864076d284f7cb46a694cbeb5454/bottle-0.13.4.tar.gz"
    sha256 "787e78327e12b227938de02248333d788cfe45987edca735f8f88e03472c3f47"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/68/e4/5c2020b60a55aca8d79ed55b62ad1cd7fc47ea44ad6b584e83f5f1bf58b0/cheroot-11.1.2.tar.gz"
    sha256 "bfb70c49663f63b0440f2b54dbc6b0d1650e56dfe4e2641f59b2c6f727b44aca"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/05/b1/efac073e0c297ecf2fb33c346989a529d4e19164f1759102dee5953ee17e/idna-3.14.tar.gz"
    sha256 "466d810d7a2cc1022bea9b037c39728d51ae7dad40d480fc9b7d7ecf98ba8ee3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/0f/27/056e0638a86749374d6f57d0b0db39f29509cce9313cf91bdc0ac4d91084/jaraco_functools-4.4.0.tar.gz"
    sha256 "da21933b0417b89515562656547a77b4931f98176eb173644c0d35032a33d6bb"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/a2/f7/139d22fef48ac78127d18e01d80cf1be40236ae489769d17f35c3d425293/more_itertools-11.0.2.tar.gz"
    sha256 "392a9e1e362cbc106a2457d37cabf9b36e5e12efd4ebff1654630e76597df804"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/ca/64/50be6fbac9c79fe2e4c17401a467da2d8764d82833d83cec325afe5cab32/pymongo-4.17.0.tar.gz"
    sha256 "70ffa08ba641468cc068cf46c06b34f01a8ce3489f6411309fcb5ceabe6b2fc0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/43/b8/7a707d60fea4c49094e40262cc0e2ca6c768cca21587e34d3f705afec47e/requests-2.34.0.tar.gz"
    sha256 "7d62fe92f50eb82c529b0916bb445afa1531a566fc8f35ffdc64446e771b856a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"mongo-orchestration", "-b", "127.0.0.1", "-p", "8889", "--no-fork", "start"]
    require_root true
  end

  test do
    system bin/"mongo-orchestration", "-h"
  end
end
