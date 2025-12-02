class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/mongodb-labs/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/70/ff/16fc299ee7ee4a2f48fc9a6eefde91ab0817073437da39b9c1cda3e4045e/mongo_orchestration-0.11.1.tar.gz"
  sha256 "53e70343ab6d3e2085a45f8c16d60244308d9e8964bd92ef38a21928cef68a52"
  license "Apache-2.0"
  head "https://github.com/mongodb-labs/mongo-orchestration.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c1d7954111921cd1c3d5732c609a2ab70eac6e367076168e6d06d3e0101f3e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c93813a8acd72462b3dcf2ea08a979c8fefe07c02ed1b01d2e1c98535a5a7f49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad88e0ec99ae46684172548f54c6f46a919988834290b0067471dcf867e3b934"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4da7a11412b82a5464981c572faef97c0205b72731665522c419ed6f807031b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8e3203aeef12c19cb16206b7bf860617e0c8e0723bc37278e9964ee65da0a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bcd6c74dd468e3764d2850e3d73a23ee343ef14cbc74260c6b7792a830576c0"
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
    url "https://files.pythonhosted.org/packages/f4/01/5ef06df932a974d016ab9d7f93e78740b572c4020016794fd4799cdc09c6/cheroot-11.0.0.tar.gz"
    sha256 "dd414eda6bdb15140e864bc1d1c9625030375d14cbe0b290092867368924a52f"
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
    url "https://files.pythonhosted.org/packages/f7/ed/1aa2d585304ec07262e1a83a9889880701079dde796ac7b1d1826f40c63d/jaraco_functools-4.3.0.tar.gz"
    sha256 "cfd13ad0dd2c47a3600b439ef72d8615d482cedcff1632930d6f28924d92f294"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/9d/7b/a709c85dc716eb85b69f71a4bb375cf1e72758a7e872103f27551243319c/pymongo-4.15.3.tar.gz"
    sha256 "7a981271347623b5319932796690c2d301668ac3a1965974ac9f5c3b8a22cea5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
