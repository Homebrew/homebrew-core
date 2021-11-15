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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a204015b6e5ae6bc3e41b266a0115d2fe90babcac7e3278fb52c69b13509201d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "210b9496cf1db0eb9aee0d7635ea84f68595148a3debf35bda8c7ca53c0f2809"
    sha256 cellar: :any_skip_relocation, monterey:       "ceaf3add5b3ff118eccd6b923342e91b113aa9aa89e1bc3c46c33017561a1268"
    sha256 cellar: :any_skip_relocation, big_sur:        "5eb13db692e829105df6d6a3eed791e592161e888b8e0c03fd58e994db59f78a"
    sha256 cellar: :any_skip_relocation, catalina:       "f80c5c9be67fe1e07c3402f29c1ca9abe25c52a4d7224327300f59b299e87dcf"
    sha256 cellar: :any_skip_relocation, mojave:         "9dbe4b489474f9f08896f373c64e5ce1629395aa359715b382a1d376604d6888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80d000d19330123c831170857288a486d1687befcb0016b8d2dda72a35288997"
  end

  depends_on "openssl@1.1"
  depends_on "python@3.10"
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

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
