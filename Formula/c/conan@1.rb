class ConanAT1 < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://conan.io"
  url "https://files.pythonhosted.org/packages/ee/e8/0893952ee0c0f78100a7da72aeb81f68925933ecbb730bfd664e7a4c6f1f/conan-1.66.0.tar.gz"
  sha256 "04d2ad0f6ec6f055d95fa0a157b55fdea9328ae67f51b11e7d26e9d9d2f76ab9"
  license "MIT"
  revision 1

  livecheck do
    url "https://github.com/conan-io/conan.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0f91960c3b28c5086806e506926a6f2764936a3388d3ff44bea6a1bef1d9a16"
    sha256 cellar: :any,                 arm64_sonoma:  "7468618737d770ecc1aa658b663bde1a4fd72e8d17d20e388c944e8ec0b03eb8"
    sha256 cellar: :any,                 arm64_ventura: "9851e1d9c1a92facad60c7b74d650e42aee8b379a48b5d30efa6da829bf863ef"
    sha256 cellar: :any,                 sonoma:        "d73286f9ba4c4a4bea134d0ae292a75f4ea02bfd26f9588789e0bc8981bea8d4"
    sha256 cellar: :any,                 ventura:       "599fa47760c3d27b62cbd99062e371eaa338be5420ec2c8b1c2eb93389575cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03eb636eacae32dba689475822c2df48ef33649a4bce321d34d6730fc48da8e9"
  end

  keg_only :versioned_formula

  depends_on "pkgconf" => :build
  depends_on "cmake" => :test
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12" # https://github.com/conan-io/conan/issues/17220#issuecomment-2437381133

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/fd/04/1c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215/bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/5f/d4/e834d929be54bfadb1f3e3b931c38e956aaa3b235a46a3c764c26c774902/fasteners-0.19.tar.gz"
    sha256 "b4f37c3ac52d8a445af3a66bce57b33b5e90b97c696b7b984f530cf8f0ded09c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/af/92/b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccff/jinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "node-semver" do
    url "https://files.pythonhosted.org/packages/f1/4e/1d9a619dcfd9f42d0e874a5b47efa0923e84829886e6a47b45328a1f32f1/node-semver-0.6.1.tar.gz"
    sha256 "4016f7c1071b0493f18db69ea02d3763e98a633606d7c7beca811e53b5ac66b7"
  end

  resource "patch-ng" do
    url "https://files.pythonhosted.org/packages/c1/b2/ad3cd464101435fdf642d20e0e5e782b4edaef1affdf2adfc5c75660225b/patch-ng-1.17.4.tar.gz"
    sha256 "627abc5bd723c8b481e96849b9734b10065426224d4d22cd44137004ac0d4ace"
  end

  resource "pluginbase" do
    url "https://files.pythonhosted.org/packages/f3/07/753451e80d2b0bf3bceec1162e8d23638ac3cb18d1c38ad340c586e90b42/pluginbase-1.0.1.tar.gz"
    sha256 "ff6c33a98fce232e9c73841d787a643de574937069f0d18147028d70d7dee287"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e4/e8/6ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392f/urllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"conan", "search", "zlib", "--remote", "conancenter"

    system bin/"conan", "install", "zlib/1.2.11@", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
