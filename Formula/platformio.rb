class Platformio < Formula
  include Language::Python::Virtualenv

  desc "Professional collaborative platform for embedded development"
  homepage "https://platformio.org/"
  url "https://files.pythonhosted.org/packages/b8/f0/4e9941349c3450838667d323545b256d91b723a4685a1e056f01642b851e/platformio-5.1.1.tar.gz"
  sha256 "c1688692ec2de34dcc38c5a3f99e98f5eb469a1589445d9a35322fb39d9c7902"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c0df677646bdd1ef465ee4b4c19a208d4f177ee55335cf69291a89511f93c976"
    sha256 cellar: :any_skip_relocation, big_sur:       "35e55074a397b5aebbe070b544e92d94ad740657666ef211b6280bdb8485678d"
    sha256 cellar: :any_skip_relocation, catalina:      "790c0ae34e8542297af1f6852c27bda0261a606246af32058aa06751c3d3953a"
    sha256 cellar: :any_skip_relocation, mojave:        "1b113213a5bf0c2e76813d37ab22326c7367548eeb6dd56c2af74d9a9c3acaf0"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/77/47/19e5951cc6ed771669906d2946b3deac32a35a9a155f730be49d8fa73dc9/aiofiles-0.6.0.tar.gz"
    sha256 "e0281b157d3d5d59d803e3f4557dcc9a3dff28a4dd4829a9ff478adae50ca092"
  end

  resource "ajsonrpc" do
    url "https://files.pythonhosted.org/packages/6d/ca/c90cc6a4d8efa69de9c874d18f804422d22e8df5f5c1593e15536fb60652/ajsonrpc-1.1.0.tar.gz"
    sha256 "0a01c2b56d20c59868ed96afbc468e0cd73e29b156e2c02c1ed3365e4e42b9ac"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/ea/80/3d2dca1562ffa1929017c74635b4cb3645a352588de89e90d0bb53af3317/bottle-0.12.19.tar.gz"
    sha256 "a9d73ffcbc6a1345ca2d7949638db46349f5b2b77dac65d6494d45c23628da2c"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/bd/e9/72c3dc8f7dd7874812be6a6ec788ba1300bfe31570963a7e788c86280cb9/h11-0.12.0.tar.gz"
    sha256 "47222cb6067e4a307d535814917cd98fd0a57b6788ce715755fa2b6c28b56042"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/3d/fc/4ce147e3997cd0ea470ad27112087545cf83bf85015ddb3054673cb471bb/ifaddr-0.1.7.tar.gz"
    sha256 "1f9e8a6ca6f16db5a37d3356f07b6e52344f6f9f7e806d618537731669eb1a94"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/9b/3a/9f586ba2932b17d89c11373f28d7350a09bf87a6274ef29a37605c996c1e/marshmallow-3.10.0.tar.gz"
    sha256 "4ab2fdb7f36eb61c3665da67a7ce281c8900db08d72ba6bf0e695828253581f7"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/6b/b5/f7022f2d950327ba970ec85fb8f85c79244031092c129b6f34ab17514ae0/pyelftools-0.27.tar.gz"
    sha256 "cde854e662774c5457d688ca41615f6594187ba7067af101232df889a6b7a66b"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/d4/52/3be868c7ed1f408cb822bc92ce17ffe4e97d11c42caafce0589f05844dd0/semantic_version-2.8.5.tar.gz"
    sha256 "d2cb2de0558762934679b9a104e82eca7af448c9f4974d1f3eeccff651df8a54"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/3a/06/ded663a1ddea8b11a2027d88ff0e757f9cdb812310f18bee33ef7270112f/starlette-0.14.2.tar.gz"
    sha256 "7d49f4a27f8742262ef1470608c59ddbc66baf37c148e938c7038e6bc7a998aa"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/26/6c/6ace1cd024a27dd692c80fd31c8e51e6b81bde459e2cae06b5ab30fc37d2/uvicorn-0.13.4.tar.gz"
    sha256 "3292251b3c7978e8e4a7868f4baf7f7f7bb7e40c759ecc125c37e99cdea34202"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/2b/a4/aded0882f8f1cddd68dcd531309a15bf976f301e6a3554055cc06213c227/wsproto-1.0.0.tar.gz"
    sha256 "868776f8456997ad0d9720f7322b746bbe9193751b5b290b7f924659377c8c38"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/4b/21/a09b4a8fdd0f9068c8134de31c4258f43c1c35352e89bdcb8994dae180d9/zeroconf-0.28.8.tar.gz"
    sha256 "4be24a10aa9c73406f48d42a8b3b077c217b0e8d7ed1e57639630da520c25959"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/pio boards ststm32")
    assert_match "ST Nucleo F401RE", output
  end
end
