class Bzt < Formula
  include Language::Python::Virtualenv

  desc "BlazeMeter Taurus"
  homepage "https://gettaurus.org/"
  url "https://files.pythonhosted.org/packages/ec/c9/e0fb1360e4a6bd7df422fc473200f0edb45027e59d97d16f72384645577c/bzt-1.16.25.tar.gz"
  sha256 "0c6ecfb3ce35158f4c4e9f4b45e404a96eddd819090004d53135c8f0c7960b77"
  license "Apache-2.0"
  head "https://github.com/Blazemeter/taurus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdd7fe0060c1b4b9d088385ffde79cfcf6fe3e4e5789ca40b7c2a41f55bc3b57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c53e0857180edfa67303e96adafb7ae9fe1aae2a78d0bb2425bf23c5bcc0ff80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03d850dac36cf48770bdf52f9e5b77087486a11189103456663c4ea2b6dc6f95"
    sha256 cellar: :any_skip_relocation, ventura:        "fd266d6d5a6dee60c911aa2ad5d73123902d0cceded2507bf6c28460202b34e0"
    sha256 cellar: :any_skip_relocation, monterey:       "37ab85a00e29f306996d2a4b46e15f05e276e0c9fc82fd876b93a5dea66aa952"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d12f057100fa87017096d9a5fdfdfd816bf42235753d4f96e8c5695fcf70a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b7c7f795fdec8371e483e2b914d9dcf1ee727658dace06d303434f627436cce"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libcython"
  depends_on "numpy"
  depends_on "python-certifi"
  depends_on "python-pytz"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "aiodogstatsd" do
    url "https://files.pythonhosted.org/packages/8d/ea/d2d79661f213f09df0e9f56d25dbae41501880822e5c85a0a6d6857baa55/aiodogstatsd-0.16.0.post0.tar.gz"
    sha256 "f783c7d6d74edd160b34141ff5f069c9a935bb32636823e39e36f0d1dbe14931"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/d6/12/6fc7c7dcc84e263940e87cbafca17c1ef28f39dae6c0b10f51e4ccc764ee/aiohttp-3.8.5.tar.gz"
    sha256 "b9552ec52cc147dbf1944ac7ac98af7602e51ea2dcd076ed194ca3c0d1c7d0bc"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "astunparse" do
    url "https://files.pythonhosted.org/packages/f3/af/4182184d3c338792894f34a62672919db7ca008c89abee9b564dd34d8029/astunparse-1.6.3.tar.gz"
    sha256 "5ad93a8456f0d084c3456d059fd9a92cce667963232cbf763eac3bc5b7940872"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/87/d6/21b30a550dafea84b1b8eee21b5e23fa16d010ae006011221f33dcd8d7f8/async-timeout-4.0.3.tar.gz"
    sha256 "4640d96be84d82d02ed59ea2b7105a0f7b33abe8703703cd0ab0bf87c427522f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "bidict" do
    url "https://files.pythonhosted.org/packages/f2/be/b31e6ea9c94096a323e7a0e2c61480db01f07610bb7e7ea72a06fd1a23a8/bidict-0.22.1.tar.gz"
    sha256 "1e0f7f74e4860e6d0943a05d4134c63a2fad86f3d4732fb265bd79e4e856d81d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/78/6b/4e5481ddcdb9c255b2715f54c863629f1543e97bc8c309d1c5c131ad14f2/colorlog-6.7.0.tar.gz"
    sha256 "bd94bd21c1e13fac7bd3153f4bc3a7dc0eb0974b8bc2fdf1a989e474f6e582e5"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/d1/91/d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081c/cssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/c4/31/54dd222e02311c2dbc9e680d37cbd50f4494ce1ee9b04c69980e4ec26f38/dill-0.3.7.tar.gz"
    sha256 "cc1c8b182eb3013e24bd475ff2e9295af86c1a38eb1aff128dac8962a9ce3c03"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/8c/1f/49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22/frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "fuzzyset2" do
    url "https://files.pythonhosted.org/packages/e4/f4/8a14a8fdf98941995bc028bd8a3c6c79d1d4d9bf5839e234cb6aad56936b/fuzzyset2-0.2.2.tar.gz"
    sha256 "71f08c69ece31e73631f402ee532f74115255290819747d25e55661b5029cfb5"
  end

  resource "hdrpy" do
    url "https://files.pythonhosted.org/packages/47/8c/159be762f787888651f9895a60d8564d2c1df5b2581cc733823b45759cfd/hdrpy-0.3.3.tar.gz"
    sha256 "8461ed2c0d577468e5499f8b685d9bf9660b72b8640bff02c78ba1f1b9bf5185"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0c/84/e58c665f4ebb03d2fbeb28b51afb0743f846db18a5b594ed8b8973676ddf/humanize-4.8.0.tar.gz"
    sha256 "9783373bf1eec713a770ecaa7c2d7a7902c98398009dfa3d8a2df91eec9311e8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "influxdb" do
    url "https://files.pythonhosted.org/packages/86/4f/a9c524576677c1694b149e09d4fd6342e4a1d9a5f409e437168a14d6d150/influxdb-5.3.1.tar.gz"
    sha256 "46f85e7b04ee4b3dee894672be6a295c94709003a7ddea8820deec2ac4d8b27a"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  end

  resource "molotov" do
    url "https://files.pythonhosted.org/packages/54/22/5820c7cad221514a04d9cdada884476e35c5972d7b84f88755094beab4fc/molotov-2.6.tar.gz"
    sha256 "0f52d260b4566709882a12710eff9b5863604f88c9bc03749cab4f9de462771a"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/dc/a1/eba11a0d4b764bc62966a565b470f8c6f38242723ba3057e9b5098678c30/msgpack-1.0.5.tar.gz"
    sha256 "c075544284eadc5cddc70f4757331d99dcbc16b2bbd4849d15f8aae4cf36d31c"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "multiprocess" do
    url "https://files.pythonhosted.org/packages/68/e0/a77ca96e772e13c828fa52f3ad370d413bef194aeaf78b7c6611870ad815/multiprocess-0.70.15.tar.gz"
    sha256 "f20eed3036c0ef477b07a4177cf7c1ba520d9a2677870a4f47fe026f0cd6787e"
  end

  resource "progressbar33" do
    url "https://files.pythonhosted.org/packages/71/fc/7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6b/progressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-engineio" do
    url "https://files.pythonhosted.org/packages/48/81/9432274cde756b04a17ae6420639fe3190bcb09eb090dee546586be9aabb/python-engineio-4.7.0.tar.gz"
    sha256 "8b4f30ba58a5bff001801127227f44a1da0c0a22045f798c1a13ebb0d618e2a3"
  end

  resource "python-socketio" do
    url "https://files.pythonhosted.org/packages/12/b5/5084ce6c772ee2f7d20714a116976cdb5d24c850745b1364d43e024e5a89/python-socketio-5.9.0.tar.gz"
    sha256 "dc42735f65534187f381fde291ebf620216a4960001370f32de940229b2e7f8f"
  end

  resource "pyvirtualdisplay" do
    url "https://files.pythonhosted.org/packages/86/9f/23e5a82987c26d225139948a224a93318d7a7c8b166d4dbe4de7426dc4e4/PyVirtualDisplay-3.0.tar.gz"
    sha256 "09755bc3ceb6eb725fb07eca5425f43f2358d3bf08e00d2a9b792a1aedd16159"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/77/76/224d6eeab59c705bb7c1986b91b3e756dd65efbcf5bda148d39c3cbf402b/rapidfuzz-3.2.0.tar.gz"
    sha256 "448d031d9960fea7826d42bd4284156fc68d3b55a6946eb34ca5c6acf960577b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/f5/fc/0b73d782f5ab7feba8d007573a3773c58255f223c5940a7b7085f02153c3/terminaltables-3.1.10.tar.gz"
    sha256 "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/38/44/d747807b707465625ba5e18371bc7c448925314d7217ced1801162b74ca6/websocket-client-1.6.2.tar.gz"
    sha256 "53e95c826bf800c4c465f50093a8c4ff091c7327023b10bfaff40cf1ef170eaa"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a4/99/78c4f3bd50619d772168bec6a0f34379b02c19c9cced0ed833ecd021fd0d/wheel-0.41.2.tar.gz"
    sha256 "0c5ac5ff2afb79ac23ab82bab027a0be7b5dbcf2e54dc50efe4bf507de1f7985"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
  end

  def install
    # Enable finding cython, which is keg-only
    site_packages = Language::Python.site_packages("python3.11")
    (libexec/site_packages/"homebrew-libcython.pth").write Formula["libcython"].opt_libexec/site_packages

    virtualenv_install_with_resources
  end

  test do
    cmd = "#{bin}/bzt -v -o execution.executor=locust -o execution.iterations=1 -o execution.scenario.requests.0=https://gettaurus.org/"
    # assert_match /INFO: Samples count: 1, .*% failures/, shell_output(cmd)
    system(cmd)
  end
end
