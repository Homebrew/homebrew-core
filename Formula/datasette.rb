class Datasette < Formula
  include Language::Python::Virtualenv
  desc "Open source multi-tool for exploring and publishing data"
  homepage "https://datasette.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/01/70/11734b4cb005a556f20e65e7f04df1c22a85f5ef731d86c9a63c2476ada3/datasette-0.48.tar.gz"
  sha256 "40f9b8b29d9b0962d33f657177484f6d3d5b51cc58588c508b57ce24e78d5e3b"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cee3c858dc117818bd4a42e8ce8bd16ac3936a89042c813a3b37bab95f4986cf" => :catalina
    sha256 "10348d0aeeb7440d9d4b0bee2e9fc9fa9e2fe11607e132d46f719ac3e568630d" => :mojave
    sha256 "ed707180ff9941e48a74175118f5fed013d72b52a800cf67a20bf8feaa4d3474" => :high_sierra
  end

  depends_on "python@3.8"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/2b/64/437053d6a4ba3b3eea1044131a25b458489320cb9609e19ac17261e4dc9b/aiofiles-0.5.0.tar.gz"
    sha256 "98e6bcfd1b50f97db4980e182ddd509b7cc35909e903a8fe50d8849e02d815af"
  end

  resource "asgi-csrf" do
    url "https://files.pythonhosted.org/packages/e1/64/7ed484baad9fa6139260fe27ece6905e4746b59e9d2b70c7e2c48a4f1cf9/asgi-csrf-0.7.tar.gz"
    sha256 "6cccf20390bb0990691f6a796c782cfb00d0d04485bd39fc988d14e8e6aea9d0"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/6d/6e/6e0ff19e7054491be7390fec2b711f838b31282fd3afe28057314d72f11b/asgiref-3.2.10.tar.gz"
    sha256 "7e51911ee147dd685c3c8b805c0ad0cb58d360987b56953878f8c06d2d1c6f1a"
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
    url "https://files.pythonhosted.org/packages/34/5a/abaa557d20b210117d8c3e6b0b817ce9b329b2e81f87612e60102a924323/h11-0.9.0.tar.gz"
    sha256 "33d4bca7be0fa039f4e84d50ab00531047e53d6ee8ffbc83501ea602c169cae1"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/d9/6f/aad92c3f090e2f74dd728d58d3bba4c832d35199814af99673ee7300b582/httptools-0.1.1.tar.gz"
    sha256 "41b573cf33f64a8f8f3400d0a7faf48e1888582b6f6e02b82b9bd4f0bf7497ce"
  end

  resource "hupper" do
    url "https://files.pythonhosted.org/packages/41/24/ea90fef04706e54bd1635c05c50dc9cf87cda543c59303a03e7aa7dda0ce/hupper-1.10.2.tar.gz"
    sha256 "3818f53dabc24da66f65cf4878c1c7a9b5df0c46b813e014abdd7c569eb9a02a"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/68/1a/f27de07a8a304ad5fa817bbe383d1238ac4396da447fa11ed937039fa04b/itsdangerous-1.1.0.tar.gz"
    sha256 "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19"
  end

  resource "janus" do
    url "https://files.pythonhosted.org/packages/9a/76/fbb89aa5d3cb5f3fec6ce74d34cf980ccd475b015d1a59cb5a14fe4cd2c5/janus-0.5.0.tar.gz"
    sha256 "0700f5537d076521851d19b7625545c5e76f6d5792ab17984f28230adcc3b34c"
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
    url "https://files.pythonhosted.org/packages/8c/97/122b87ce55c3ba7b75b3b5e9b12a55b86d72aae4cb56d1d11c93a1ff0002/Pint-0.14.tar.gz"
    sha256 "9aa450ebb9d722ed03fa9a450104cfd16c479b49f862d547c6f77320de597f72"
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

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/fb/07/7620525be7468b6c82b10f40d39e5fc6200cfab6c7f4012f1756b1e6d6d6/uvicorn-0.11.8.tar.gz"
    sha256 "46a83e371f37ea7ff29577d00015f02c942410288fb57def6440f2653fff1d26"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/84/2e/462e7a25b787d2b40cf6c9864a9e702f358349fc9cfb77e83c38acb73048/uvloop-0.14.0.tar.gz"
    sha256 "123ac9c0c7dd71464f58f1b4ee0bbd81285d96cdda8bc3519281b8973e3a461e"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/e9/2b/cf738670bb96eb25cb2caf5294e38a9dc3891a6bcd8e3a51770dbc517c65/websockets-8.1.tar.gz"
    sha256 "5c65d2da8c6bce0fca2528f69f44b2f977e06954c8512a952222cea50dad430f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/datasette --get '/:memory:.csv?sql=select+3*5'")
    assert_match "<title>Datasette:", shell_output("#{bin}/datasette --get '/'")
  end
end
