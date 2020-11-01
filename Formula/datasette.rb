class Datasette < Formula
  include Language::Python::Virtualenv
  desc "Open source multi-tool for exploring and publishing data"
  homepage "https://datasette.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/10/97/200b5374474b3ac3a520424431c9d03bc14ac1c9515abbe1216e041a9045/datasette-0.51.1.tar.gz"
  sha256 "383c93bd7a2926dbe19e0c42d96963801c95399f5f8529e609cf9339879ca0f0"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9f49e442196e44153a534500766d6625de497b03b1b47ab3d13bdbf2cfe99201" => :catalina
    sha256 "520238b3cd936d655911f828b8a225c89efa68b8535e6583a66c033fd9d08263" => :mojave
    sha256 "d5d140172298b8b58a0f7712ab9b96c3b96e26a180ce2adbee94ec93b294ced4" => :high_sierra
  end

  depends_on "python@3.9"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/77/47/19e5951cc6ed771669906d2946b3deac32a35a9a155f730be49d8fa73dc9/aiofiles-0.6.0.tar.gz"
    sha256 "e0281b157d3d5d59d803e3f4557dcc9a3dff28a4dd4829a9ff478adae50ca092"
  end

  resource "asgi-csrf" do
    url "https://files.pythonhosted.org/packages/02/fc/f3670d30faa648bb5e0774f45fdb5173ae06fd6f5ad9795ea4ee1d05928b/asgi-csrf-0.7.1.tar.gz"
    sha256 "77bfb2a3311643fd2304d0f11f72160559acbbd1a35730a54208135ded3f21a3"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/3e/34/fb6c2b2b858d27cdc6703e26e304d56e2300c33719b9407eae54a6b80423/asgiref-3.3.0.tar.gz"
    sha256 "cd88907ecaec59d78e4ac00ea665b03e571cb37e3a0e37b3702af1a9e86c365a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/22/01/01dc716e71eeead6c6329a19028548ac4a5c2a769a130722548c63479038/h11-0.11.0.tar.gz"
    sha256 "3c6c61d69c6f13d41f1b80ab0322f1872702a3ba26e12aa864c928f6a43fbaab"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/42/c8/25a57dcc665cfbc1ad67ff7a10912e5bc01375345c91cd41bfd7fd92c874/httpcore-0.12.0.tar.gz"
    sha256 "2526a38f31ac5967d38b7f593b5d8c4bd3fa82c21400402f866ba3312946acbf"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/28/1e/1726b212239edc78999874e0ba8c86baec99e5d36ccfae9911514feae80c/httpx-0.16.1.tar.gz"
    sha256 "126424c279c842738805974687e0518a94c7ae8d140cd65b9c4f77ac46ffa537"
  end

  resource "hupper" do
    url "https://files.pythonhosted.org/packages/41/24/ea90fef04706e54bd1635c05c50dc9cf87cda543c59303a03e7aa7dda0ce/hupper-1.10.2.tar.gz"
    sha256 "3818f53dabc24da66f65cf4878c1c7a9b5df0c46b813e014abdd7c569eb9a02a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/68/1a/f27de07a8a304ad5fa817bbe383d1238ac4396da447fa11ed937039fa04b/itsdangerous-1.1.0.tar.gz"
    sha256 "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19"
  end

  resource "janus" do
    url "https://files.pythonhosted.org/packages/7c/1b/8769c2dca84dd8ca92e48b14750c7106ff4313df4fee651dbc3cd9e345a9/janus-0.6.1.tar.gz"
    sha256 "4712e0ef75711fe5947c2db855bc96221a9a03641b52e5ae8e25c2b705dd1d0c"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz"
    sha256 "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/50/ff/6c0b3817037c21fc46cb0eabd97152da6bb5bb33b1bfeaba1e7cc865a8d2/mergedeep-1.3.0.tar.gz"
    sha256 "19a91123e71ae27cb22335f4d03aec040026c89d4ff6df42595f7e7223a83dfb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145/packaging-20.4.tar.gz"
    sha256 "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8"
  end

  resource "Pint" do
    url "https://files.pythonhosted.org/packages/2b/d4/18becb51e9e242640010362b38dde187ecc0d5caeb0a689a2a60083b1ca3/Pint-0.16.1.tar.gz"
    sha256 "d43a2e9ae003164978b60fdf8cd920d8581e1a5991df8dded29b00f4850ec83a"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-baseconv" do
    url "https://files.pythonhosted.org/packages/33/d0/9297d7d8dd74767b4d5560d834b30b2fff17d39987c23ed8656f476e0d9b/python-baseconv-1.2.2.tar.gz"
    sha256 "0539f8bd0464013b05ad62e0a1673f0ac9086c76b43ebf9f833053527cd9931b"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/46/40/a933ac570bf7aad12a298fc53458115cc74053474a72fbb8201d7dc06d3d/python-multipart-0.0.5.tar.gz"
    sha256 "f7bb5f611fc600d15fa47b3974c8aa16e93724513b49b5f95c81e6624c83fa43"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/70/e2/1344681ad04a0971e8884b9a9856e5a13cc4824d15c047f8b0bbcc0b2029/rfc3986-1.4.0.tar.gz"
    sha256 "112398da31a3344dc25dbf477d8df6cb34f9278a94fee2625d89e4514be8bb9d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/1d/f9/cf632de3d5b68634ca82fd37489aea772919a0f42b45033ac845fa17ef24/uvicorn-0.12.2.tar.gz"
    sha256 "8ff7495c74b8286a341526ff9efa3988ebab9a4b2f561c7438c3cb420992d7dd"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/datasette --get '/:memory:.csv?sql=select+3*5'")
    assert_match "<title>Datasette:", shell_output("#{bin}/datasette --get '/'")
  end
end
