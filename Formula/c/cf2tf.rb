class Cf2tf < Formula
  include Language::Python::Virtualenv

  desc "Cloudformation templates to Terraform HCL converter"
  homepage "https://github.com/DontShaveTheYak/cf2tf"
  url "https://files.pythonhosted.org/packages/1e/0f/6bcd8bba734912fce43afa887d6008bc3774edea3f32231cd82c99492cd1/cf2tf-0.6.1.tar.gz"
  sha256 "6c14e8fa2d69d6a174048faba2d2fac65435397f4778de24447a4167f1890b9a"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/DontShaveTheYak/cf2tf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "125c2c0584ff699e89476a028c2d88b8d563c3637cf728774489baf29c84f157"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a50e53578521b158c9b9fafd4efb9fa41597e9c6d9f1b285fa018a173f902ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "290e0f722eb9227a5bdb544628f20b3444028feab9a18cac64e2b99b2186594c"
    sha256 cellar: :any_skip_relocation, sonoma:         "975df470bf91341df24536749c96a8722d7529bf028974fed6c4f3f85dd37c03"
    sha256 cellar: :any_skip_relocation, ventura:        "bef9b8c51541df653296e6bdc8dfa51250b9670a131bbb2ad3eca4df973f1475"
    sha256 cellar: :any_skip_relocation, monterey:       "e07cf310aab5f2088202c34da491f44aad44a553d46aefadf342c17113a9262a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fca13f9d77c3cd1a8a0d63e84c33f80cd4f96c0d257df4d86a0fb0d3f2fbb946"
  end

  depends_on "cmake" => :build
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "six"

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/b3/45/cee7af549b6fa33f04531e402693a772b776cd9f845a2cbeca99cfac3331/GitPython-3.1.38.tar.gz"
    sha256 "4d683e8957c8998b58ddb937e3e6cd167215a180e1ffd4da769ab81c620a89fe"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "levenshtein" do
    url "https://files.pythonhosted.org/packages/d5/db/6163301400a4b2d86f6f0d05d36eab23880de047d0e41081a186519d4dfa/Levenshtein-0.23.0.tar.gz"
    sha256 "de7ccc31a471ea5bfafabe804c12a63e18b4511afc1014f23c3cc7be8c70d3bd"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/e5/d0/18209bb95db8ee693a9a04fe056ab0663c6d6b1baf67dd50819dd9cd4bd7/pytest-7.4.2.tar.gz"
    sha256 "a766259cfab564a2ad52cb1aae1b881a75c3eb7e34ca3779697c23ed47c47069"
  end

  resource "python-levenshtein" do
    url "https://files.pythonhosted.org/packages/06/3d/d238db3ca97bf749abcec7146991ab5a1ef71610daf8e331eb86f3dddb25/python-Levenshtein-0.23.0.tar.gz"
    sha256 "156a0198cdcc659c90c8d3863d0ed3f4f0cf020608da71da52ac0f0746ef901a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/27/36/22741bb354505ca284c2149a4c7fdee396a6cdeae3f4c0614acf6b0ee27e/rapidfuzz-3.4.0.tar.gz"
    sha256 "a74112e2126b428c77db5e96f7ce34e91e750552147305b2d361122cbede2955"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "thefuzz" do
    url "https://files.pythonhosted.org/packages/d2/bd/aecf6079c3843cfff370d37138d4f0b36ffdffa94549c20e6d74eda799f9/thefuzz-0.19.0.tar.gz"
    sha256 "6f7126db2f2c8a54212b05e3a740e45f4291c497d75d20751728f635bb74aa3d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def python
    which("python3.12")
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
