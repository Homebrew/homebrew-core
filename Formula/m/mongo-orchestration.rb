class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/mongodb-labs/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/c9/3b/6e579eb7aae04e95c194e6ca57666bc4d1cd0dff4f81de0b3f7e663222b5/mongo_orchestration-0.11.2.tar.gz"
  sha256 "6f0996e5bb072e8dbd0009289b31debb88a647f562c486cfc2c73583ab059993"
  license "Apache-2.0"
  head "https://github.com/mongodb-labs/mongo-orchestration.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d947869a1425ba65bd120e8a01e5a1e7aa89e04570087d01e6f8e4b1eeaa84e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8abfa8767d3c0617274ec058461270540048ce7a18508e351b1adf336fb9e614"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12a4823e7756b7ec2369525e92d081ee9e383c8390eb3e8b3ac018b7f28818da"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7d4c6465fc14d7529ca7c1d9639c42b451b87f7bf437b403606f0d0a91c3c17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8d8159cae821be828e79d479e72f9f580b1ead8de133a394f921f57bd3cacb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c69f6f30a71390e06116c17c48441f0a9b0a801de76177ae5acd93fb28596da0"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/7a/71/cca6167c06d00c81375fd668719df245864076d284f7cb46a694cbeb5454/bottle-0.13.4.tar.gz"
    sha256 "787e78327e12b227938de02248333d788cfe45987edca735f8f88e03472c3f47"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/0f/27/056e0638a86749374d6f57d0b0db39f29509cce9313cf91bdc0ac4d91084/jaraco_functools-4.4.0.tar.gz"
    sha256 "da21933b0417b89515562656547a77b4931f98176eb173644c0d35032a33d6bb"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/65/9c/a4895c4b785fc9865a84a56e14b5bd21ca75aadc3dab79c14187cdca189b/pymongo-4.16.0.tar.gz"
    sha256 "8ba8405065f6e258a6f872fe62d797a28f383a12178c7153c01ed04e845c600c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
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
