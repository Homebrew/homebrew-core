class AwsElasticbeanstalk < Formula
  include Language::Python::Virtualenv

  desc "Client for Amazon Elastic Beanstalk web service"
  homepage "https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html"
  url "https://files.pythonhosted.org/packages/1a/cf/6c65ba11a8e62c8fda110ab6768017db2739cd020c7c61653a6127e088ae/awsebcli-3.11.0.tar.gz"
  sha256 "f127424bd6314662970ff50b1bf9e1f74ce4e25b30a1dc3ecdd1436b15424314"

  bottle do
    cellar :any_skip_relocation
    sha256 "43a9aa3531948182341a794b947ec6492ae6adc3e089937fff0732e03a9ed5fa" => :high_sierra
    sha256 "a974b7c700d101a02421f3dd144887359864cc7a0a0ef04b1b6455fc8fd93a0f" => :sierra
    sha256 "0688d3d7d0bf2bdf3b8ec5879bd38128ff8f5264cd228121b7aba9f0796c27c1" => :el_capitan
    sha256 "2c94590b75813f08daaa69489012bcd11bb0509f39d4f79569f03bfe30ea923c" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/c2/04/be691f2ad9d70252476bb0d74a1e46390364d751b021b747b7dc1c8dfb0c/blessed-1.14.2.tar.gz"
    sha256 "2342125fd4f27f00d2677798bd06be2e6a1178e77c0298080abe4f720070693b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/26/fc/9f28dc538d3af815afe18b1afc540fe5b163d1143d7646302bc56a9e4448/botocore-1.7.25.tar.gz"
    sha256 "8d834b296faebf55d0be6d63a2a4ee9e30062f70b1c3e0bb5d97286a7854c5cb"
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
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"
    sha256 "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/67/f6/ad4d6964da803ffe0ec9d513b0be6924be0f502636c17781308561f08034/pathspec-0.5.0.tar.gz"
    sha256 "aa3a071054d4740b963c91a3127a5e0e1358351718bae2a3f731ec24fb0bdd1f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
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
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/db/40/6ffc855c365769c454591ac30a25e9ea0b3e8c952a1259141f5b9878bd3d/tabulate-0.7.5.tar.gz"
    sha256 "9071aacbd97a9a915096c1aaf0dc684ac2672904cd876db5904085d6dac9810e"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/06/19/f00725a8aee30163a7f257092e356388443034877c101757c1466e591bf8/websocket_client-0.44.0.tar.gz"
    sha256 "15f585566e2ea7459136a632b9785aa081093064391878a448c382415e948d72"
  end

  resource "backports.ssl_match_hostname" do
    url "https://files.pythonhosted.org/packages/76/21/2dc61178a2038a5cb35d14b61467c6ac632791ed05131dda72c20e7b9e23/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  def install
    virtualenv_install_with_resources
    bash_completion.install libexec/"bin/eb_completion.bash"
  end

  test do
    system "#{bin}/eb", "--version"
  end
end
