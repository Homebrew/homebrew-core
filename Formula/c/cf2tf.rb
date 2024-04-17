class Cf2tf < Formula
  include Language::Python::Virtualenv

  desc "Cloudformation templates to Terraform HCL converter"
  homepage "https://github.com/DontShaveTheYak/cf2tf"
  url "https://files.pythonhosted.org/packages/ea/3f/c1861f5f8f6c8430c34b3cac46aa7c8723a403a5bffec448a8acf1cfd23c/cf2tf-0.6.2.tar.gz"
  sha256 "7b2ec09154279d247a3dada67b82c571143805ff7e9bb6d7ebada8fa6908a773"
  license "GPL-3.0-only"
  revision 2
  head "https://github.com/DontShaveTheYak/cf2tf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e28a62fa312f81eae9513c123dd2626cdb9c2cbf52a683efb15ecf8b63227b96"
    sha256 cellar: :any,                 arm64_ventura:  "db94156da483ed9c5510ae121b6753a4205c0ad8aaf7b7212e646cfcbbe2992d"
    sha256 cellar: :any,                 arm64_monterey: "6fe74f08cb8e5cd8b9577712b6b7e9b765bdf5c689f0822c00838819bf102b5f"
    sha256 cellar: :any,                 sonoma:         "0c1c8631f73e83af01bde372171270212ac77fb64355b68266c8b28f4c0b6a22"
    sha256 cellar: :any,                 ventura:        "252934d9353f1fb794f7fa216e39d4820bba39f219047aced31d3e5632030e42"
    sha256 cellar: :any,                 monterey:       "61a0da1838d4900c88272405c9b2cc04cc04b0fca6afcf8653b3f0da1478a3e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0a92970a1b1a959f81784f1dc6c48eabf0897efe7ba6f7239d992f02c3697fc"
  end

  depends_on "cmake" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/b6/a1/106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662/GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/54/c6/43f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59/pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/80/1f/9d8e98e4133ffb16c90f3b405c43e38d3abb715bb5d7a63a5a684f7e46a3/pytest-7.4.4.tar.gz"
    sha256 "2cf0005922c6ace4a3e2ec8b4080eb0d9753fdc93107415332f50ce9e7994280"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/2a/8b/c5b482bd99c7b4b8e6db31b707333d85f33f0c7eebb72724a1e932f3b6b1/rapidfuzz-3.8.1.tar.gz"
    sha256 "a357aae6791118011ad3ab4f2a4aa7bd7a487e5f9981b390e9f3c2c5137ecadf"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "thefuzz" do
    url "https://files.pythonhosted.org/packages/75/e1/9859c094bb47674c2e9b3f51518f488d665941422352f9f7880b72bc86f4/thefuzz-0.20.0.tar.gz"
    sha256 "a25e49786b1c4603c7fc6e2d69e6bc660982a2919698b536ff8354e0631cc40d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cf2tf", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      AWSTemplateFormatVersion: '2010-09-09'
      Description: 'Hello World S3 Bucket CloudFormation Stack'
      Resources:
        HelloWorldS3Bucket:
          Type: 'AWS::S3::Bucket'
          Properties:
            BucketName: hello-world-s3-bucket
            AccessControl: PublicRead
    EOS

    expected = <<~EOS
      resource "aws_s3_bucket" "hello_world_s3_bucket" {
        bucket = "hello-world-s3-bucket"
        acl = "public-read"
      }
    EOS

    system bin/"cf2tf", "test.yaml", "-o", testpath
    assert_match expected, (testpath/"resource.tf").read

    assert_match version.to_s, shell_output("#{bin}/cf2tf --version")
  end
end
