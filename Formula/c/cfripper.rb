class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io"
  url "https://files.pythonhosted.org/packages/ae/d0/60d97ad7c0d70ca4d3bc3fbb1f30fa783d233a2c0bd0fb86277e47de5b79/cfripper-1.17.0.tar.gz"
  sha256 "9ce1905bbca8eea0baef16163b8fd4fd25de6310ddccb3967ce95fe9fb11d2eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "03fce8fdb110abe04ca4eec783ed708fd2fb01d8e3f358999fceb22ba09b6100"
    sha256 cellar: :any,                 arm64_sonoma:  "0b3d809b297a9b7b5c6c0333160f08bbd674838fa8e44da89cdd041feed93500"
    sha256 cellar: :any,                 arm64_ventura: "8b00fbe7d33cb30d022cb689315832f724d9792b7c4a4d59868fe3096137f2f6"
    sha256 cellar: :any,                 sonoma:        "c6d807e3db8e2c05d9c0629244cfd3d4294f5cd7e9b38a19a9c6d3e4c8b3f1a6"
    sha256 cellar: :any,                 ventura:       "6068f26085d7281d2960ee2ece98b3280fc225efd4243e3e3e939834cb16ab18"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4340c362fb1fb0e46a2828299fcd3e0aef875b1435aa37d20cc734584ef1935b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c1701b52666ee8e0552babf0db957dc989d2a0ef1008b67e385dee957cbfeea"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/6e/c5/3c55e916745e5f43de2ea8b5c71d97ec7828b0fd9d03bc2c56aede328fd8/boto3-1.37.4.tar.gz"
    sha256 "024c37c2f85f4b907f5fc817d0db6fda7fd6ab3c6148ee4ed35fe7cecdf7db0c"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e1/4b/ddf3bdfdae59a6de8936be04e6d79235612ca546e2517c4449fa6e969ef3/botocore-1.37.4.tar.gz"
    sha256 "7e15cd487617440e9eac3144044b6a2bd833d7f3e2bed6a2865693cc11489cc3"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
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
    url "https://files.pythonhosted.org/packages/26/3d/9bee2861d40333e9666e87d09f7a420e0c3590e822d0e47b8999b4e6f6f5/pycfmodel-1.0.1.tar.gz"
    sha256 "1451795d8509a6b78d3d2147da1bd56dad33713f2452c4ce625077d7a89dc222"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b7/ae/d5220c5c52b158b1de7ca89fc5edb72f304a70a4c540c84c8844bf4008de/pydantic-2.10.6.tar.gz"
    sha256 "ca5daa827cce33de7a42be142548b0096bf05a7e7b365aebfa5f8eeec7128236"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/fc/01/f3e5ac5e7c25833db5eb555f7b7ab24cd6f8c322d3a3ad2d67a952dc0abc/pydantic_core-2.27.2.tar.gz"
    sha256 "eb026e5a4c1fee05726072337ff51d1efb6f59090b7da90d30ea58625b1ffb39"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/2f/24/91c037f47e434172c2112d65c00c84d475a6715425e3315ba2cbb7a87e66/pydash-8.0.5.tar.gz"
    sha256 "7cc44ebfe5d362f4f5f06c74c8684143c5ac481376b059ff02570705523f9e2e"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/39/24/1390172471d569e281fcfd29b92f2f73774e95972c965d14b6c802ff2352/s3transfer-0.11.3.tar.gz"
    sha256 "edae4977e3a122445660c7c114bba949f9d191bae3b34a096f18a1c8c354527a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cfripper", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath/"test.json").write <<~JSON
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
    JSON

    output = shell_output("#{bin}/cfripper #{testpath}/test.json --format txt 2>&1")
    assert_match "no AWS Account ID was found in the config.", output
    assert_match "Valid: True", output

    assert_match version.to_s, shell_output("#{bin}/cfripper --version")
  end
end
