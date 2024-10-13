class Cf2tf < Formula
  include Language::Python::Virtualenv

  desc "Cloudformation templates to Terraform HCL converter"
  homepage "https://github.com/DontShaveTheYak/cf2tf"
  url "https://files.pythonhosted.org/packages/52/00/94c12acc1ed644df1c3ee658068929c33863fccfdd2f8ab9236d58eb4496/cf2tf-0.8.0.tar.gz"
  sha256 "f36bbf5abacdf70baeb12529a7ae4ba1c5f748112c240bef4a5ed0e0e654f44c"
  license "GPL-3.0-only"
  revision 2
  head "https://github.com/DontShaveTheYak/cf2tf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "15fb3f3dcbb51f0199b99c49f0a2418c25ac0743cfe5f0425ecb420fb3f175e7"
    sha256 cellar: :any,                 arm64_sonoma:   "81faddfd3fff52781eb6f7002261830a04315e72466db07d0cfa8f75423b0641"
    sha256 cellar: :any,                 arm64_ventura:  "ceacab7ba6ff7bda06e6ef57e57d43b0c4fad897c77dfd8a5726de523297a68d"
    sha256 cellar: :any,                 arm64_monterey: "fc768744c0aa9922b26469dc6a6e5a1c1ca5de68e12e63730d5ba8cc5fe7b84d"
    sha256 cellar: :any,                 sonoma:         "fdda58e03437e9c5923181a6e1aaf795ff2fae8615bc4c69cf28c908668e87fb"
    sha256 cellar: :any,                 ventura:        "e20f31937319483b2e6c37db2c7ba43f6e6a70315d43bf19d2cf8f60dcdc5529"
    sha256 cellar: :any,                 monterey:       "bd68798d1621261fd82519b6c2b810dee2bec69638e7b838d9f2e53cc5520d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "062a354928f67915531f6f1b9afb1c69a277b418fa904831140ba50eea8d558e"
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
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/a6/58/e993ca5357553c966b9e73cb3475d9c935fe9488746e13ebdf9b80fae508/pytest-8.2.2.tar.gz"
    sha256 "de4bb8104e201939ccdc688b27a89a7be2079b22e2bd2b07f806b6ba71117977"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/50/b9/22b4848fc842b17c4446433d5d472007c9799dbe8dd90bc0f6d60767c29d/rapidfuzz-3.9.3.tar.gz"
    sha256 "b398ea66e8ed50451bce5997c430197d5e4b06ac4aa74602717f792d8d8d06e2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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
    url "https://files.pythonhosted.org/packages/81/4b/d3eb25831590d6d7d38c2f2e3561d3ba41d490dc89cd91d9e65e7c812508/thefuzz-0.22.1.tar.gz"
    sha256 "7138039a7ecf540da323792d8592ef9902b1d79eb78c147d4f20664de79f3680"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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
