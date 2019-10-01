class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-python-lint/"
  url "https://github.com/aws-cloudformation/cfn-python-lint/archive/v0.24.3.tar.gz"
  sha256 "8eb134f1f7fb89f6f1330deb52a945a6453df2843f069e6079033999565a766e"

  bottle do
    cellar :any_skip_relocation
    sha256 "a44388078df49b262c96cb124a43c7a9d2723e2607df5c34e8626410a824dd31" => :catalina
    sha256 "4cf34d8084c0242d637ca8ebbbcfb870a10e5308046f6b8ead291a0db1a5959f" => :mojave
    sha256 "9ee1fe510c4b31ab69a5ebb3e8e8e49ae048c3a97e3d047f9df0e8796f391d9a" => :high_sierra
  end

  depends_on "python"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/cc/d9/931a24cc5394f19383fbbe3e1147a0291276afa43a0dc3ed0d6cd9fda813/attrs-19.1.0.tar.gz"
    sha256 "f0b870f674851ecbfbbbd364d6b5cbdff9dcedbc7f3f5e18a6891057f21fe399"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/9e/48/2d3cf2acbac9a3761e8427e7cc02ed28640c06cf62d35341f5f98ab5c8ea/aws-sam-translator-1.14.0.tar.gz"
    sha256 "3c615bff465fcf6a7990b9f84d002d55c75cd3e52d98e727d24959756ab0f0b1"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/d0/1d/f8c53e023ef980d1292967a19cad94f7db97b23376b021d9f8d838ca61d7/boto3-1.9.238.tar.gz"
    sha256 "2fc1c407a5ab08cfcf54eb4171d85c523bd27019ab890de257d018af2770f71d"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/ed/45/a22db7510cff4037395787c23b2acde75529785b93850eaecbed99cb9902/botocore-1.12.238.tar.gz"
    sha256 "6ec3297b87d3e2c4d88b009f91061aaecdb2ceef6d9be9386394571353909adb"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/62/85/7585750fd65599e88df0fed59c74f5075d4ea2fe611deceb95dd1c2fb25b/certifi-2019.9.11.tar.gz"
    sha256 "e4f3620cfea4f83eedc95b24abd9cd56f3c4b146dd0177e83a21b4eb49e21e50"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"
    sha256 "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/2c/30/f0162d3d83e398c7a3b70c91eef61d409dea205fb4dc2b47d335f429de32/jmespath-0.9.4.tar.gz"
    sha256 "bde2aef6f44302dfb30320115b17d030798de8c4110e28d5cf6cf91a7a31074c"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/30/ac/9b6478a560627e4310130a9e35c31a9f4d650704bbd03946e77c73abcf6c/jsonpatch-1.24.tar.gz"
    sha256 "cbb72f8bf35260628aea6b508a107245f757d1ec839a19c34349985e2c05645a"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/52/e7/246d9ef2366d430f0ce7bdc494ea2df8b49d7a2a41ba51f5655f68cfe85f/jsonpointer-2.0.tar.gz"
    sha256 "c192ba86648e05fdae4f08a17ec25180a9aef5008d973407b581798a83975362"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/92/d2/8768983d6e4bb1478ea08e7bc186304f47b99c22bfd711caa8e9becb0361/jsonschema-3.0.2.tar.gz"
    sha256 "8d4a2b7b6c2237e0199c8ea1a6d3e05bf118e289ae2b9d7ba444182a2959560d"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/b9/66/b2638d96a2d128b168d0dba60fdc77b7800a9b4a5340cefcc5fc4eae6295/pyrsistent-0.15.4.tar.gz"
    sha256 "34b47fa169d6006b32e99d4b3c4031f155e6e68ebcc107d6454852e8e0ee6533"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/ad/99/5b2e99737edeb28c71bcbec5b5dda19d0d9ef3ca3e92e3e925e7c0bb364c/python-dateutil-2.8.0.tar.gz"
    sha256 "c89805f6f4d64db21ed966fda138f8a5ed7a4fdbc1a8ee329ce1b74e3c74da9e"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/e3/e8/b3212641ee2718d556df0f23f78de8303f068fe29cdaa7a91018849582fe/PyYAML-5.1.2.tar.gz"
    sha256 "01adf0b6c6f61bd11af6e10ca52b7d4057dd0be0343eb9283c878cf3af56aee4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/39/12/150cd55c606ebca6725683642a8e7068cd6af10f837ce5419a9f16b7fb55/s3transfer-0.2.1.tar.gz"
    sha256 "6efc926738a3cd576c2a79725fed9afde92378aa5c6a957e3af010cb019fac9d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ff/44/29655168da441dff66de03952880c6e2d17b252836ff1aa4421fba556424/urllib3-1.25.6.tar.gz"
    sha256 "9a107b99a5393caf59c7aa3c1249c16e6879447533d0887f4336dde834c7be86"
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
