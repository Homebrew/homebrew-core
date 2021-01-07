class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://files.pythonhosted.org/packages/4a/b1/a1fdbc631212d9e27cc462d6b01a7ec50eed32ce1b5de80b2eb690b382c8/docker-compose-1.27.4.tar.gz"
  sha256 "5a5690f24c27d4b43dcbe6b3fae91ba680713208e99ee863352b3bae37bcaa83"
  license "Apache-2.0"
  revision 2
  head "https://github.com/docker/compose.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "c577b372471df97876b4783a4b63ba1f13aeb6dbf6884d65cd5fe562b9b9d9f4" => :big_sur
    sha256 "16253360c909ddeabf7aaaa254f93c6041eddd1eb90a3c1b48bc7f0bbe190fc3" => :catalina
    sha256 "f78859e7f5ae97e0d16ced6885ae0254041bac63d12dfe557f83371149044391" => :mojave
    sha256 "41a4fdb093db662f77497e3f190574703a6609c215e34278b121949d5a367aef" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.9"

  uses_from_macos "libffi"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/81/d0/641b698d05f0eaea4df4f9cebaff573d7a5276228ef6b7541240fe02f3ad/attrs-20.2.0.tar.gz"
    sha256 "26b54ddbbb9ee1d34d5d3668dd37d6cf74990ab23c828c2888dccdceee395594"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/66/6a/98e023b3d11537a5521902ac6b50db470c826c682be6a8c661549cb7717a/cffi-1.14.4.tar.gz"
    sha256 "1a465cbe98a7fd391d47dce4b8f7e5b921e6cd805ef421d04f5f66ba8f06086c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/5d/4b/7bb135c5787c003cdbc44990c5f41908f0f37135e0bb554e880d90fd5f6f/cryptography-3.1.1.tar.gz"
    sha256 "9d9fc6a16357965d282dd4ab6531013935425d0dc4950df2e0cf2a1b1ac1017d"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
    sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/b3/48/014af5285463adb8079f32f603c0d6d19c16d92a113ebacc6b07522dcff5/docker-4.3.1.tar.gz"
    sha256 "bad94b8dd001a8a4af19ce4becc17f41b09f228173ffe6a4e0355389eef142f2"
  end

  resource "dockerpty" do
    url "https://files.pythonhosted.org/packages/8d/ee/e9ecce4c32204a6738e0a5d5883d3413794d7498fe8b06f44becc028d3ba/dockerpty-0.4.1.tar.gz"
    sha256 "69a9d69d573a0daa31bcd1c0774eeed5c15c295fe719c61aca550ed1393156ce"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/cf/a1/20d00ce559a692911f11cadb7f94737aca3ede1c51de16e002c7d3a888e0/paramiko-2.7.2.tar.gz"
    sha256 "7f36f4ba2c0d81d219f4595e35f70d56cc94f9ac40a6acdf51d6ca210ce65035"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/4d/70/fd441df751ba8b620e03fd2d2d9ca902103119616f0f6cc42e6405035062/pyrsistent-0.17.3.tar.gz"
    sha256 "2e636185d9eb976a18a8a8e96efce62f2905fea90041958d8cc2a189756ebf3e"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/33/3d/a0c00002bae69321f5b87ea7ed123ddf1933e09d3ff658d277889698ee59/python-dotenv-0.14.0.tar.gz"
    sha256 "8c10c99a1b25d9a68058a1ad6f90381a62ba68230ca93966882a4dbc3bc9c33d"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/f5/be/716342325d6d6e05608e3a10e15f192f3723e454a25ce14bc9b9d1332772/texttable-1.6.3.tar.gz"
    sha256 "ce0faf21aa77d806bbff22b107cc22cce68dc9438f97a2df32c93e9afa4ce436"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
  end

  resource "websocket_client" do
    url "https://files.pythonhosted.org/packages/8b/0f/52de51b9b450ed52694208ab952d5af6ebbcbce7f166a48784095d930d8c/websocket_client-0.57.0.tar.gz"
    sha256 "d735b91d6d1692a6a181f2a8c9e0238e5f6373356f561bb9dc4c7af36f452010"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "contrib/completion/bash/docker-compose"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"
  end

  test do
    system bin/"docker-compose", "--help"
  end
end
