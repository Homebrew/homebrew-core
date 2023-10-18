class Gcalcli < Formula
  include Language::Python::Virtualenv

  desc "Easily access your Google Calendar(s) from a command-line"
  homepage "https://github.com/insanum/gcalcli"
  url "https://files.pythonhosted.org/packages/e8/d9/9d1f03b9b47c3082bf664a2f789a3aded0674dca9e0b894540d754b937cc/gcalcli-4.3.0.tar.gz"
  sha256 "d00081460276027196e8fb957880b29ba4f22ea43136f9e232a9408016abc110"
  license "MIT"
  revision 6
  head "https://github.com/insanum/gcalcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "774adf923bf875af1cbeef54ede2d1b1b51984e6cd19c677e05889138be313f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e74db3b4bab0c82fd5b9160feb9f43247a338178c24d6d14aa9a0585a8573af3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cda280b92fbf376c896afd8fdc0062c987f991ad9bf6245987ae5bc54f018a4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d49289a3e0e523e1ed9faebaa9c0d0724e97b944e57d1c576f3f8d68f7b489fc"
    sha256 cellar: :any_skip_relocation, ventura:        "5667cb74efa2b2580d4e912a2c38b3b61beb46fadce583194faebbbf32a1547e"
    sha256 cellar: :any_skip_relocation, monterey:       "3ec81a2e9dccfce96261df2f50265fcdaffeb1e447cef7c4123d1ec72138769e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e629f0cf43c4e3c3b1466325b727a79b7d8d4dccf5f1e39ac8c1e31d25984a9"
  end

  depends_on "python-certifi"
  depends_on "python-pyparsing"
  depends_on "python@3.12"
  depends_on "six"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/3f/5d/9138d873205a38e5264a78fd4ebf446fc987f20e2566719ed6eee69c200a/google-api-core-2.12.0.tar.gz"
    sha256 "c22e01b1e3c4dcd90998494879612c38d0a3411d1f7b679eb89e2abe3ce1f553"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/19/c9/ce294e72438f987b36151c49f91c1853d0fc37d59d7c360e926dae4f8a17/google-api-python-client-2.104.0.tar.gz"
    sha256 "bbc66520e7fe9417b93fd113f2a0a1afa789d686de9009b6e94e48fdea50a60f"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/45/71/0f19d6f51b6ea291fc8f179d152d675f49acf88cb44f743b37bf51ef2ec1/google-auth-2.23.3.tar.gz"
    sha256 "6864247895eea5d13b9c57c9e03abb49cb94ce2dc7c58e91cba3248c7477c9e3"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/0f/7a/83c3a1f8419d66f91672ad7f2cea57d044f7f0b3c1740389a468ff3937ed/google-auth-httplib2-0.1.1.tar.gz"
    sha256 "c64bc555fdc6dd788ea62ecf7bccffcf497bf77244887a3f3d7a5a02f8e3fc29"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/95/41/f9d4425eac5cec8c0356575b8f183e8f1f7206875b1e748bd3af4b4a8a1e/googleapis-common-protos-1.61.0.tar.gz"
    sha256 "8a64866a97f6304a7179873a465d6eee97b7a24ec6cfd78e0f575e96b821240b"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/52/5c/f2c0778278259089952f94b0884ca27a001a17ffbd992ebe30c841085f4c/protobuf-4.24.4.tar.gz"
    sha256 "5a70731910cd9104762161719c3d883c960151eea077134458503723b60e3667"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/gcalcli --client-id=foo --client-secret=bar --noauth_local_webserver list", "foo")
    assert_match "Go to the following link in your browser:", output
  end
end
