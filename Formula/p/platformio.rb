class Platformio < Formula
  include Language::Python::Virtualenv

  desc "Your Gateway to Embedded Software Development Excellence"
  homepage "https://platformio.org/"
  url "https://files.pythonhosted.org/packages/fa/f0/32f8e9dc3cfb418af074f06ee419ab5f490df01141196d0f20d14b5037c5/platformio-6.1.10.tar.gz"
  sha256 "046ad5bf0f723a98f0fc98cf6ef71cfd57dd85dc6c547af0e801fbc952f8fe58"
  license "Apache-2.0"
  head "https://github.com/platformio/platformio-core.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "deebf94df2e6ac9a89adbf2acb0988117b449c751c382626824991d549c6eb19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de24e10ac2cb470d5d077c53aae69986c53b289d70ca436a1bfe4861769a0dae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52b5a93f37f71b599e819fa786f2bcce5cd0542b50de8d03211e369052aabe45"
    sha256 cellar: :any_skip_relocation, ventura:        "f03e1e58af8a2c18b4c114506855a4b618fa59f5a09b9775d8071a483d55207f"
    sha256 cellar: :any_skip_relocation, monterey:       "7104624559c7e53b2e9e9abc913ecf4ec4034fa8437f4211bbd8dd6631a8079b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e0b83d3001a93a9d01e3ea5ddb22d67cd3ceab71fa7e5de8e35bbd125fade56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cfa97602afa880dd52efe7cde23c378279f72d1a9e7b99b7dbf24fadeaf9a7d"
  end

  depends_on "python-certifi"
  depends_on "python-tabulate"
  depends_on "python@3.11"

  resource "ajsonrpc" do
    url "https://files.pythonhosted.org/packages/da/5c/95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1/ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/28/99/2dfd53fd55ce9838e6ff2d4dac20ce58263798bd1a0dbe18b3a9af3fcfce/anyio-3.7.1.tar.gz"
    sha256 "44a3c9aba0f5defa43261a8b3efb97891f2bd7d804e0e1f56419befa1adfc780"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/fd/04/1c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215/bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/e4/e0/3e49c0f91f3e8954806c1076f4eae2c95a9d3ed2546f267c683b877d327b/marshmallow-3.20.1.tar.gz"
    sha256 "5d2371bbe42000f2b3fb5eaa065224df7d8f8597bc19a1bbfa5bfe7fba8da889"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/0e/35/e76da824595452a5ad07f289ea1737ca0971fc6cc7b6ee9464279be06b5e/pyelftools-0.29.tar.gz"
    sha256 "ec761596aafa16e282a31de188737e5485552469ac63b60cfcccf22263fd24ff"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/0f/62/0b59c1ed652ce7935f018ae2fc3bdab2d8a6a5675f914ed9618eb8ee70b3/starlette-0.31.0.tar.gz"
    sha256 "7df0a3d8fa2c027d641506204ef69239d19bf9406ad2e77b319926e476ac3042"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/4c/b3/aa7eb8367959623eef0527f876e371f1ac5770a3b31d3d6db34337b795e6/uvicorn-0.23.2.tar.gz"
    sha256 "4d3cc12d7727ba72b64d12d3cc7743124074c0a69f7b201512fc50c3e3f1569a"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c9/4a/44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5a/wsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/pio boards ststm32")
    assert_match "ST Nucleo F401RE", output
  end
end
