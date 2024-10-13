class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/cf/e8/95fd33c9a28fc93da3ab6d42e4596e1bac4381aa86b7dc86db37d74920f3/cfn_lint-1.16.1.tar.gz"
  sha256 "e7b6a2fbb39368974044e7ecd109bed56224cf11b9bd92ebeb5e8ae5d5754725"
  license "MIT-0"

  livecheck do
    url :stable
    regex(/href=.*?cfn_lint[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "473d19e2c0739eac81b3051889dcc466dcc4c06e0243b645ed8625e4e0297c42"
    sha256 cellar: :any,                 arm64_sonoma:  "eadbcf6177e39d50e953d5092e19050974a129b10dde4ac0816072a58a20ce28"
    sha256 cellar: :any,                 arm64_ventura: "0d4d782b9fbda7bc4c07b0f80953b9a316784b5f522454def3f3ce5a4c7fef99"
    sha256 cellar: :any,                 sonoma:        "1300bd442d34d50e93dce94a7eb5d372a3fe71a45240f203065b7dba4c0fcbde"
    sha256 cellar: :any,                 ventura:       "bf12e6bf4cff1124b6d46c3e92079c4040aed1f2d2333db4852de146032bb914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6f1e6f152f3c007323083ec3df48f992b35d9a97a07148ec728c63bd978539"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/1c/41/fbd5be5d25c6bdceb92ecb5232a794eb7a3a9cfdf111f28b27cb3c19fb77/aws_sam_translator-1.91.0.tar.gz"
    sha256 "0cdfbc598f384c430c3ec064f6008d80c5a0d58f1dc45ca4e331ae5c43cb4697"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b8/29/10988ceaa300ddc628cb899875d85d9998e3da4803226398e002d95b2741/boto3-1.35.39.tar.gz"
    sha256 "670f811c65e3c5fe4ed8c8d69be0b44b1d649e992c0fc16de43816d1188f88f1"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/f7/28/d83dbd69d7015892b53ada4fded79a5bc1b7d77259361eb8302f88c2da81/botocore-1.35.39.tar.gz"
    sha256 "cb7f851933b5ccc2fba4f0a8b846252410aa0efac5bfbe93b82d10801f5f8e90"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/36/2b/20ad9eecdda3f1b0dc63fb8f82d2ea99163dbca08bfa392594fc2ed81869/networkx-3.4.1.tar.gz"
    sha256 "f9df45e85b78f5bd010993e897b4f1fdb242c11e015b101bd951e5c0e29982d8"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/a9/b7/d9e3f12af310e1120c21603644a1cd86f59060e040ec5c3a80b8f05fae30/pydantic-2.9.2.tar.gz"
    sha256 "d155cef71265d1e9807ed1c32b4c8deec042a44a50a4188b25ac67ecd81a9c0f"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/e2/aa/6b6a9b9f8537b872f552ddd46dd3da230367754b6f707b8e1e963f515ea3/pydantic_core-2.23.4.tar.gz"
    sha256 "2584f7cf844ac4d970fba483a717dbe10c1c1c96a969bf65d61ffe94df1b2863"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/64/b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29a/rpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/a8/e0a98fd7bd874914f0608ef7c90ffde17e116aefad765021de0f012690a2/s3transfer-0.10.3.tar.gz"
    sha256 "4f50ed74ab84d474ce614475e0b8d5047ff080810aac5d01ea25231cfc944b0c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/11/8a/5a7fd6284fa8caac23a26c9ddf9c30485a48169344b4bd3b0f02fef1890f/sympy-1.13.3.tar.gz"
    sha256 "b27fd2c6530e0ab39e275fc9b683895367e51d5da91baa8d3d64db2565fec4d9"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.yml").write <<~EOS
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        IamPipeline:
          Type: "AWS::CloudFormation::Stack"
          Properties:
            TemplateURL: !Sub 'https://s3.${AWS::Region}.amazonaws.com/bucket-dne-${AWS::Region}/${AWS::AccountId}/pipeline.yaml'
            Parameters:
              DeploymentName: iam-pipeline
              Deploy: 'auto'
    EOS
    system bin/"cfn-lint", "test.yml"
  end
end
