class Mitmproxy < Formula
  include Language::Python::Virtualenv

  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://github.com/mitmproxy/mitmproxy/archive/v5.2.tar.gz"
  sha256 "976974cb89affd7971cf04566c60c0ef64a0830cce8ea9ae6c2869755c310b87"
  license "MIT"
  head "https://github.com/mitmproxy/mitmproxy.git"

  bottle do
    cellar :any
    sha256 "10cb64b3f49fa9d5b1525bffc5abf21a35982faa3a079677fccc39782e60486b" => :catalina
    sha256 "f9c919bc9ce5ba946b29e135bc77d360874f5e8049eaf661cfdaedc31083fe3d" => :mojave
    sha256 "4ce3f6c6c2d1814f09b9b32c727fb5c7baa8bb5224cd3450ec3c756bda4e645d" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "python@3.8"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1b/51/e2a9f3b757eb802f61dc1f2b09c8c99f6eb01cf06416c0671253536517b6/blinker-1.4.tar.gz"
    sha256 "471aee25f3992bd325afa3772f1063dbdbbca947a041b8b89466dc00d606f8b6"
  end

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/cd/9c/7955895f5672ecc85270244582c6b53ff95bb4c24bf77bd9271d42351635/Brotli-1.0.7.zip"
    sha256 "0538dc1744fd17c314d2adc409ea7d1b779783b89fd95bcfb0c2acc93a6ea5a7"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz"
    sha256 "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/56/3b/78c6816918fdf2405d62c98e48589112669f36711e50158a0c15d804c30d/cryptography-2.9.2.tar.gz"
    sha256 "a0c30272fb4ddda5f5ffc1089d7405b7a71b0b0f51993cb4e5dbb4590b2fc229"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/4e/0b/cb02268c90e67545a0e3a37ea1ca3d45de3aca43ceb7dbf1712fb5127d5d/Flask-1.1.2.tar.gz"
    sha256 "4efa1ae2d7c9865af48986de8aeb8504bf32c7f3d6fdc9353d34b21f4b127060"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/34/5a/abaa557d20b210117d8c3e6b0b817ce9b329b2e81f87612e60102a924323/h11-0.9.0.tar.gz"
    sha256 "33d4bca7be0fa039f4e84d50ab00531047e53d6ee8ffbc83501ea602c169cae1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/08/0a/033df0fc05fe94f72517ccd393dd9ff99b1773fd198307638e6d3568a518/h2-3.2.0.tar.gz"
    sha256 "875f41ebd6f2c44781259005b157faed1a5031df3ae5aa7bcb4628a6c0782f14"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/44/f1/b4440e46e265a29c0cb7b09b6daec6edf93c79eae713cfed93fbbf8716c5/hpack-3.0.0.tar.gz"
    sha256 "8eec9c1f4bfae3408a3f30500261f7e6a65912dc138526ea054f9ad98892e9d2"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/e6/7f/9a4834af1010dc1d570d5f394dfd9323a7d7ada7d25586bd299fc4cb0356/hyperframe-5.2.0.tar.gz"
    sha256 "a9f5c17f2cc3c719b917c4f33ed1c61bd1f8dfac4b1bd23b7c80b3400971b41f"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/68/1a/f27de07a8a304ad5fa817bbe383d1238ac4396da447fa11ed937039fa04b/itsdangerous-1.1.0.tar.gz"
    sha256 "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz"
    sha256 "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0"
  end

  resource "kaitaistruct" do
    url "https://files.pythonhosted.org/packages/23/71/8577ca06e81c1dc0ba03a39ae32e315175ba2d9df51befa3a45f47950056/kaitaistruct-0.8.tar.gz"
    sha256 "d1d17c7f6839b3d28fc22b21295f787974786c2201e8788975e72e2a1d109ff5"
  end

  resource "ldap3" do
    url "https://files.pythonhosted.org/packages/c2/49/3bf179229a92ae87ff2dca1609c2ad599c497938f90fd5d66d02aa8e977e/ldap3-2.7.tar.gz"
    sha256 "17f04298b70bf7ecaa5db8a7d8622b5a962ef7fc2b245b2eea705ac1c24338c0"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/6d/6b/4bfca0c13506535289b58f9c9761d20f56ed89439bfe6b8e07416ce58ee1/passlib-1.7.2.tar.gz"
    sha256 "8d666cef936198bc2ab47ee9b0410c94adf2ba798e5a84bf220be079ae7ab6a8"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/c9/d5/e6e789e50e478463a84bd1cdb45aa408d49a2e1aaffc45da43d10722c007/protobuf-3.11.3.tar.gz"
    sha256 "c77c974d1dadf246d789f6dad1c24426137c9091e930dbf50e0a29c1fcf00b1f"
  end

  resource "publicsuffix2" do
    url "https://files.pythonhosted.org/packages/5a/04/1759906c4c5b67b2903f546de234a824d4028ef24eb0b1122daa43376c20/publicsuffix2-2.20191221.tar.gz"
    sha256 "00f8cc31aa8d0d5592a5ced19cccba7de428ebca985db26ac852d920ddd6fe7b"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0d/1d/6cc4bd4e79f78be6640fab268555a11af48474fac9df187c3361a1d1d2f0/pyOpenSSL-19.1.0.tar.gz"
    sha256 "9a24494b2602aaf402be5c9e30a0b82d4a5c67528fe8fb475e3f3bc00dd69507"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/f6/5b/55866e1cde0f86f5eec59dab5de8a66628cb0d53da74b8dbc15ad8dabda3/pyperclip-1.8.0.tar.gz"
    sha256 "b75b975160428d84608c26edba2dec146e7799566aea42c1fe1b32e72b6028f2"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/92/28/612085de3fae9f82d62d80255d9f4cf05b1b341db1e180adcf28c1bf748d/ruamel.yaml.clib-0.2.0.tar.gz"
    sha256 "b66832ea8077d9b3f6e311c4a53d06273db5dc2db6e8a908550f3c14d67e718c"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/16/8b/54a26c1031595e5edd0e616028b922d78d8ffba8bc775f0a4faeada846cc/ruamel.yaml-0.16.10.tar.gz"
    sha256 "099c644a778bf72ffa00524f78dd0b6476bca94a1da344130f4bf3381ce5b954"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/29/e0/135df2e733790a3d3bcda970fd080617be8cea3bd98f411e76e6847c17ef/sortedcontainers-2.1.0.tar.gz"
    sha256 "974e9a32f56b17c1bac2aebd9dcf197f3eb9cd30553c5852a3187ad162e1a03a"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/95/84/119a46d494f008969bf0c775cb2c6b3579d3c4cc1bb1b41a022aa93ee242/tornado-6.0.4.tar.gz"
    sha256 "0fe2d45ba43b00a41cd73f8be321a44936dc1aba233dee979f17a042b83eb6dc"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/c7/90/415728875c230fafd13d118512bde3184d810d7bf798a631abc05fac09d0/urwid-2.0.1.tar.gz"
    sha256 "644d3e3900867161a2fc9287a9762753d66bd194754679adb26aede559bcccbc"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/10/27/a33329150147594eff0ea4c33c2036c0eadd933141055be0ff911f7f8d04/Werkzeug-1.0.1.tar.gz"
    sha256 "6c80b1e5ad3665290ea39320b91e1be1e0d5f60652b964a3070216de83d2e47c"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/7b/5c/7b125c14fbdbeb7913d61e5841e20a453d71d5a5d961354a384c3ceeb81c/wsproto-0.15.0.tar.gz"
    sha256 "614798c30e5dc2b3f65acc03d2d50842b97621487350ce79a80a711229edfa9d"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/b1/3d/b95e8beb3b2d165726c6105a728a1f59ae88d6bf1e3dc66375fbe149afcd/zstandard-0.13.0.tar.gz"
    sha256 "e5cbd8b751bd498f275b0582f449f92f14e64f4e03b5bf51c571240d40d43561"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("cffi")
    venv.pip_install resources
    venv.pip_install_and_link buildpath
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/mitmproxy --version 2>&1")
  end
end
