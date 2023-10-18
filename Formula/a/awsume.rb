class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://awsu.me"
  url "https://files.pythonhosted.org/packages/2f/d4/2f9621851aa22e06b0242d1c5dc2fbeb6267d5beca92c0adf875438793c2/awsume-4.5.3.tar.gz"
  sha256 "e94cc4c1d0f3cc0db8270572e2880c0641ce14cf226355bf42440b726bf453ef"
  license "MIT"
  revision 3
  head "https://github.com/trek10inc/awsume.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fa592f87d6ccbcb83a9efdcd639c9800281dd927e39bb7539ba3b5f6c0f6e2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "272f78dfde38ca43714ea5559e93b693a0f6273712deb1487c4cf32b48b4a8b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7669aeff98d3b1ef062c325aadf018918e5b8e9441d3ee610790c18af26dfd59"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b55a8b742d27019a36b36c609bce6a865249d204f3ffe587c37838f7a667bcb"
    sha256 cellar: :any_skip_relocation, ventura:        "eb94536a788a691b5548f8d05f923a9a0a1ce0f21f07a99291bbb6ea8399d501"
    sha256 cellar: :any_skip_relocation, monterey:       "7637cd5ec6b867798bc2986ec6dcca8824d66852ca89917e0a8f2236d135f737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba6912a0dfb6ea0172fbab32c1ac094892b08067bd768e82e8fe93147767a390"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "sqlite"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/1b/2f/4ccd05e765a9aa3222125da37ceced40b4133094069c4d011ca7ae37681f/boto3-1.28.65.tar.gz"
    sha256 "9d52a1605657aeb5b19b09cfc01d9a92f88a616a5daf5479a59656d6341ea6b3"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/42/30/e5e2126eca77baedbf51e48241c898d99784d272bcf2fb47f5a10360e555/botocore-1.31.65.tar.gz"
    sha256 "90716c6f1af97e5c2f516e9a3379767ebdddcc6cbed79b026fa5038ce4e5e43e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2d/01/beb7331fc6c8d1c49dd051e3611379bfe379e915c808e1301506027fce9d/psutil-5.9.6.tar.gz"
    sha256 "e4b92ddcd7dd4cdd3f900180ea1e104932c7bce234fb88976e2a3b296441225a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("bash -c '. #{bin}/awsume -v 2>&1'")

    file_path = File.expand_path("~/.awsume/config.yaml")
    shell_output(File.exist?(file_path))

    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  ACCOUNT",
                 shell_output("bash -c '. #{bin}/awsume --list-profiles 2>&1'")
  end
end
