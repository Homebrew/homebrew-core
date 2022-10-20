class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://awsu.me"
  url "https://files.pythonhosted.org/packages/2f/d4/2f9621851aa22e06b0242d1c5dc2fbeb6267d5beca92c0adf875438793c2/awsume-4.5.3.tar.gz"
  sha256 "e94cc4c1d0f3cc0db8270572e2880c0641ce14cf226355bf42440b726bf453ef"
  license "MIT"
  revision 1
  head "https://github.com/trek10inc/awsume.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79804b716d8f2dbdabbf88b8fac18ecc486227023e0d03a4ee029bf9c87b67c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26a1fe067066bb7a1d3bef4c2be7baa84402cb3d6cf9a6c82f7dfeff4d1a81ba"
    sha256 cellar: :any_skip_relocation, monterey:       "8c443ef5b7300cadef6701befe472263cdc3e3f435d453064b1219ef291f1c3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "74bff5e97ec1b1fa3a8694e6836ac7ae61b8340489782bcf6e18663a4d2f6160"
    sha256 cellar: :any_skip_relocation, catalina:       "ecb38a4a5a948525c99fa4e4c975a353af9030664b3d42ad0c646933e2fe69ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb4b020263eaee19aefefd3779c59d9f5f63b529b186fbcada81abb546ccb200"
  end

  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "sqlite"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f1/25/4773ca66ec580636c4e8ab473c9e5375a266746f3dbfe4f85235b9c67211/boto3-1.18.62.tar.gz"
    sha256 "364a0fd497147ff0e15327f653223b05e60a1afce002995e5b1106084355352e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/60/dc/d214623d85eb3c8dcb26a60ea15df43ac81747bcb26db5cc957affb4c517/botocore-1.21.62.tar.gz"
    sha256 "c92fee381c6f2771f7ec2bffaff2938b8a1c2a957560815a01ad77c975268fdd"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
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
