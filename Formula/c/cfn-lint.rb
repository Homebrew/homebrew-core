class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/18/32/4a76cf04726f363fc213512a5e1d685ffe63c81e9a517f63ef23c1c30dd5/cfn_lint-1.50.1.tar.gz"
  sha256 "10df565e9774e41c4a5a1b6dca7d09765cd534bdf22dc24add5e4ad1e118699a"
  license "MIT-0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38e3d0f28d86b2c8666eac930ef74120e4894c67c72420d8d92010fc72a3eb42"
    sha256 cellar: :any,                 arm64_sequoia: "c7fa97ca961067695cfc2407580ce72670bf3600479f14d23f17c9e08462696c"
    sha256 cellar: :any,                 arm64_sonoma:  "4dbcf28774f37c93725b4d656283ce628c6eaae1b6ac0c5fd3b349578c4d0844"
    sha256 cellar: :any,                 sonoma:        "bb994a8c23479b3d6c5e099a4b5c916ad928dc7befb89e0ee1b61b9d3fb1c94e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "081dd6c5f4e90ddccd339357486705cf82813bf2c6618621053a6b080568bef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "039e33236a2b4af697e8a690775baa5ab805ba747d43d8081b41e11f559aa75e"
  end

  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.13" # Pydantic v1 is incompatible with Python 3.14, issue ref: https://github.com/aws/serverless-application-model/issues/3831
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: ["pydantic", "rpds-py"]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/e0/09/f62aa8d076f6ba85080ec6291e61af345e9be0daf8a4094101555e054ec7/aws_sam_translator-1.109.0.tar.gz"
    sha256 "0c5e60223ae8434ce0c6bdb9a491d69ba3ec97e15c0d825d3803f7806382d804"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/55/7d/5c6fa0bb9fd5caf865b9356411793900304328bcd0bc1eda96a32a1368a6/boto3-1.42.97.tar.gz"
    sha256 "2833dbeda3670ea610ad48dff7d27cdc829dbbfcdfbc6b750b673948e949b6f0"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c6/95/c37edb602948fad2253ffd1bb3dba5b938645bd1845ee4160350136a0f41/botocore-1.42.97.tar.gz"
    sha256 "5c0bb00e32d16ff6d278cc8c9e10dc3672d9c1d569031635ac3c908a60de8310"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/18/c7/af399a2e7a67fd18d63c40c5e62d3af4e67b836a2107468b6a5ea24c4304/jsonpointer-3.1.1.tar.gz"
    sha256 "0b801c7db33a904024f6004d526dcc53bbb8a4a0f4e32bfd10beadf60adf1900"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6a/51/63fe664f3908c97be9d2e4f1158eb633317598cfa6e1fc14af5383f17512/networkx-3.6.1.tar.gz"
    sha256 "26b7c357accc0c8cde558ad486283728b65b6a95d85ee1cd66bafab4c8168509"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cb/0e/3a246dbf05666918bd3664d9d787f84a9108f6f43cc953a077e4a7dfdb7e/regex-2026.4.4.tar.gz"
    sha256 "e08270659717f6973523ce3afbafa53515c4dc5dcad637dc215b6fd50f689423"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/46/29/af14f4ef3c11a50435308660e2cc68761c9a7742475e0585cd4396b91777/s3transfer-0.16.1.tar.gz"
    sha256 "8e424355754b9ccb32467bdc568edf55be82692ef2002d934b1311dbb3b9e524"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/83/d3/803453b36afefb7c2bb238361cd4ae6125a569b4db67cd9e79846ba2d68c/sympy-1.14.0.tar.gz"
    sha256 "d3d3fe8df1e5a0b42f0e7bdf50541697dbe7d23746e894990c030e2b05e72517"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cfn-lint --version")

    (testpath/"test.yml").write <<~YAML
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
    YAML
    system bin/"cfn-lint", "test.yml"
  end
end
