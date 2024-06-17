class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io"
  url "https://files.pythonhosted.org/packages/3d/83/5c263793a35b0cc591806165876641ccae8252c1c8108d066128f5de3108/cfripper-1.15.7.tar.gz"
  sha256 "632160c24684ef2e8bd54332d93e133a8afed5455668af80801acc4e3cfecbc1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8950a69fd847c096e2da03ddf6ba35ee28f1fa55a0ecea1c51464cfdd6d76811"
    sha256 cellar: :any,                 arm64_ventura:  "6e2d5ab58d52fb2775de6550adf662ca2e8f9b5956c402c916956c1097da2b2a"
    sha256 cellar: :any,                 arm64_monterey: "21ebbdb8fbf9191ecedaf7317974a33db9ccbf0293eefb0276b19ff16deeb262"
    sha256 cellar: :any,                 sonoma:         "50ff32016260cbffa7aaf625c2c29b4434caebe6dfed6f3c09535bdbb5103da9"
    sha256 cellar: :any,                 ventura:        "68797b4ddc4a36b9380877a74b974b5f242c9c257c121bef92e586e62c52c53a"
    sha256 cellar: :any,                 monterey:       "813ce925613622e02a9894ceb31c5e15f3455d60e69dd1832ddeff43b3373aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fb72520efd4ae2096c0a8abd06bbdc2e8dab6d37bdb9694ce4949957638d2b8"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b6/3e/03069946bb33f0bb79d80ad78231ddb175aed756667016e91cbb3dec1451/boto3-1.34.124.tar.gz"
    sha256 "a91ee58fa54b170f17b2e144f038e155f92cf515f1c073ac2595e9ee45f125a8"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/4e/72/62c7daa6e2a6270aa12a15eccb254159bb64664f45f114494708a5d98ae5/botocore-1.34.124.tar.gz"
    sha256 "3f0bf79c17d656acdfdb53581224f6a38867ff2829f7428c586198f67a90ea26"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "pycfmodel" do
    url "https://files.pythonhosted.org/packages/d4/19/0c70b1942b5b27caea8c9dd9bb932ed437f122f966eeba51a25ee1b0f85f/pycfmodel-1.0.0.tar.gz"
    sha256 "2caf7eb1b6a8582902f75aeadedae081dd34ed1bb14e47665bb5185564191996"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/21/76/a622bd8e7b0b751f65884f54c0430e5910d523b8aeccf11a8bcef26fb17e/pydantic-2.7.3.tar.gz"
    sha256 "c46c76a40bb1296728d7a8b99aa73dd70a48c3510111ff290034f860c99c419e"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/02/d0/622cdfe12fb138d035636f854eb9dc414f7e19340be395799de87c1de6f6/pydantic_core-2.18.4.tar.gz"
    sha256 "ec3beeada09ff865c344ff3bc2f427f5e6c26401cc6113d77e372c3fdac73864"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/e8/90/4cc84d60b32f3f069817705eaf7e07f3bceff050b56132885b71303aff88/pydash-8.0.1.tar.gz"
    sha256 "a24619643d3c054bfd56a9ae1cb7bd00e9774eaf369d7bb8d62b3daa2462bdbd"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/ff/08/b6768d9f2da231c1396490e91471ffebb12b299a65cb369c27ec0e2a50c6/pyyaml-6.0.2rc1.tar.gz"
    sha256 "826fb4d5ac2c48b9d6e71423def2669d4646c93b6c13612a71b3ac7bb345304b"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/83/bc/fb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571/s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~EOS
      {
        "AWSTemplateFormatVersion": "2010-09-09",
        "Resources": {
          "RootRole": {
            "Type": "AWS::IAM::Role",
            "Properties": {
              "AssumeRolePolicyDocument": {
                "Version": "2012-10-17",
                "Statement": [
                  {
                    "Effect": "Allow",
                    "Principal": {
                      "AWS": "arn:aws:iam::999999999:role/someuser@bla.com"
                    },
                    "Action": "sts:AssumeRole"
                  }
                ]
              },
              "Path": "/",
              "Policies": []
            }
          }
        }
      }
    EOS

    output = shell_output("#{bin}/cfripper #{testpath}/test.json --format txt 2>&1")
    assert_match "no AWS Account ID was found in the config.", output
    assert_match "Valid: True", output

    assert_match version.to_s, shell_output("#{bin}/cfripper --version")
  end
end
