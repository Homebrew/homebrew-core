class Cf2tf < Formula
  include Language::Python::Virtualenv

  desc "Cloudformation templates to Terraform HCL converter"
  homepage "https://github.com/DontShaveTheYak/cf2tf"
  url "https://files.pythonhosted.org/packages/7f/c3/a6dfdc4848cfd4fb50e15e9449c439791a009638c2bd06b6fe6982d9afc1/cf2tf-0.9.2.tar.gz"
  sha256 "3fcae8f42f2d1aeb14deb7ef70215cc76c1f1f5cac9b465081e87729498e3ac9"
  license "GPL-3.0-only"
  revision 3
  head "https://github.com/DontShaveTheYak/cf2tf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c377a0a2577b3ff68f924dd28dbc80a04c06c70f003bec176bc255b22c416c0"
    sha256 cellar: :any,                 arm64_sequoia: "22f926d6407faeae116d1f7a7d528b67e0bdd4cfa800ac8079718cf1be2dc038"
    sha256 cellar: :any,                 arm64_sonoma:  "7c0248e0ef45b9d3ca5c2e36a4c23cca17e3eb314a07bce2dbda4a1b2d4b6719"
    sha256 cellar: :any,                 sonoma:        "88d53dafdaa9f366a86f66e9f70b54f3e7136d8bdfc9278a2dcc00a8ea2e99d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b622563b29a9536d55e0dfff735b7d4a7ad54d38de38f0db711a150124094ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1509393a4dd19c1d2618a2765fe50e2b374420418c7b954b75cb930c8c930ed7"
  end

  depends_on "cmake" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/33/f6/354ae6491228b5eb40e10d89c4d13c651fe1cf7556e35ebdded50cff57ce/gitpython-3.1.50.tar.gz"
    sha256 "80da2d12504d52e1f998772dc5baf6e553f8d2fcfe1fcc226c9d9a2ee3372dcc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/2c/21/ef6157213316e85790041254259907eb722e00b03480256c0545d98acd33/rapidfuzz-3.14.5.tar.gz"
    sha256 "ba10ac57884ce82112f7ed910b67e7fb6072d8ef2c06e30dc63c0f604a112e0e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "thefuzz" do
    url "https://files.pythonhosted.org/packages/81/4b/d3eb25831590d6d7d38c2f2e3561d3ba41d490dc89cd91d9e65e7c812508/thefuzz-0.22.1.tar.gz"
    sha256 "7138039a7ecf540da323792d8592ef9902b1d79eb78c147d4f20664de79f3680"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cf2tf", shell_parameter_format: :click)
  end

  test do
    (testpath/"test.yaml").write <<~YAML
      AWSTemplateFormatVersion: '2010-09-09'
      Description: 'Hello World S3 Bucket CloudFormation Stack'
      Resources:
        HelloWorldS3Bucket:
          Type: 'AWS::S3::Bucket'
          Properties:
            BucketName: hello-world-s3-bucket
            AccessControl: PublicRead
    YAML

    expected = <<~HCL
      resource "aws_s3_bucket" "hello_world_s3_bucket" {
        bucket = "hello-world-s3-bucket"
        acl = "public-read"
      }
    HCL

    system bin/"cf2tf", "test.yaml", "-o", testpath
    assert_match expected, (testpath/"resource.tf").read

    assert_match version.to_s, shell_output("#{bin}/cf2tf --version")
  end
end
