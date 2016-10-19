class AwsElasticbeanstalk < Formula
  include Language::Python::Virtualenv

  desc "Client for Amazon Elastic Beanstalk web service"
  homepage "https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-reference-eb.html"
  url "https://files.pythonhosted.org/packages/1a/45/8b841c3d996f743f6a53f6cd1d2efdc5b6d757561df6f44e9bd7c50a619b/awsebcli-3.8.3.tar.gz"
  sha256 "35cc565a9d7ff8a2402e8fc2b86a9af0979ad1231b646b0871f7aed8c285bba4"

  bottle do
    cellar :any_skip_relocation
    sha256 "14ac27f17fb8905b884331941d66e217f59a0b7a99ba6ecd7bcfb81d05c311de" => :sierra
    sha256 "6d19e81c52a26572d0d5cacf855fa4b4bd2d3d430f9902af9936d2048021aacf" => :el_capitan
    sha256 "48c790551ab2544021fc570895dfa5adec0c5a0772c5eec88db7a4c95a03f85a" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/0f/56/2ff802d1a91ea50f7597328d6048aa3995b329b284c05d464aa24d6d5635/blessed-1.9.5.tar.gz"
    sha256 "b93b5c7600814638c0913c8325608327a24e3731977d9a4f003ecf37b08ca6e5"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/60/2d/479d822e36918446ed3c094022e0b341bc6bf187fc07c19efb8fbf5b0e30/botocore-1.4.64.tar.gz"
    sha256 "1906185fd3ff225e14bc433f328402157ccd82bfcab6cf37daf3d136ce96fb56"
  end

  resource "cement" do
    url "https://files.pythonhosted.org/packages/70/60/608f0b8975f4ee7deaaaa7052210d095e0b96e7cd3becdeede9bd13674a1/cement-2.8.2.tar.gz"
    sha256 "8765ed052c061d74e4d0189addc33d268de544ca219b259d797741f725e422d2"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/2c/f8/719f2b240e2b546a8ee779ac74e54754ccf2f17baad728e89188d70e0b5f/docker-py-1.7.2.tar.gz"
    sha256 "95b1d14c4ae49dfbb724332cda9c63fb67628b8bdee79c321f2d405cf7a8d04c"
  end

  resource "dockerpty" do
    url "https://files.pythonhosted.org/packages/8d/ee/e9ecce4c32204a6738e0a5d5883d3413794d7498fe8b06f44becc028d3ba/dockerpty-0.4.1.tar.gz"
    sha256 "69a9d69d573a0daa31bcd1c0774eeed5c15c295fe719c61aca550ed1393156ce"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/37/38/ceda70135b9144d84884ae2fc5886c6baac4edea39550f28bcd144c1234d/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/8f/d8/6e3e602a3e90c5e3961d3d159540df6b2ff32f5ab2ee8ee1d28235a425c1/jmespath-0.9.0.tar.gz"
    sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/14/9d/c9d790d373d6f6938d793e9c549b87ad8670b6fa7fc6176485e6ef11c1a4/pathspec-0.3.4.tar.gz"
    sha256 "7605ca5c26f554766afe1d177164a2275a85bb803b76eba3428f422972f66728"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f9/6d/07c44fb1ebe04d069459a189e7dab9e4abfe9432adcd4477367c25332748/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "semantic_version" do
    url "https://files.pythonhosted.org/packages/8e/0e/33052dd97ab9d07dae8ddffcfb2740efe58c46d72efbc060cf6da250439f/semantic_version-2.5.0.tar.gz"
    sha256 "3baad35dcb074a49419539cea6a33b484706b6c2dd03f05b67763eba4c1bb65c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/92/3e/7d05feb005057009c323ff5edcb3800fb5d53435a649207192e710d8c175/texttable-0.8.5.tar.gz"
    sha256 "c2b554b0c20c866f061cf08a315354278590b312ee178199a29bfde7a944f986"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/a3/1e/b717151e29a70e8f212edae9aebb7812a8cae8477b52d9fe990dcaec9bbd/websocket_client-0.37.0.tar.gz"
    sha256 "678b246d816b94018af5297e72915160e2feb042e0cde1a9397f502ac3a52f41"
  end

  def install
    virtualenv_install_with_resources
    bash_completion.install libexec/"bin/eb_completion.bash"
  end

  test do
    system "#{bin}/eb", "--version"
  end
end
