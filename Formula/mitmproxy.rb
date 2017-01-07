class Mitmproxy < Formula
  include Language::Python::Virtualenv

  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://github.com/mitmproxy/mitmproxy/archive/v1.0.2.tar.gz"
  sha256 "0458b4ad3cedbc238decc7d736e693cd220c7977592b57052e181d404e1152b4"
  head "https://github.com/mitmproxy/mitmproxy.git"

  bottle do
    sha256 "ff3bf4cc87211c6f0948435aedd440c70e35f39a2eb1b595447da91710b7cd65" => :sierra
    sha256 "80cafefb38dbca6c2871ab56c83e143a7505a72b4e882dd8e5b7e1f741ec8b55" => :el_capitan
    sha256 "de6027e10d8d9250a4950191ee0ef048e73c68557d7e93fe9a11d8705e293d57" => :yosemite
  end

  option "with-pyamf", "Enable action message format (AMF) support for python"

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "openssl@1.1"
  depends_on :python3
  depends_on "protobuf" => :optional

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1b/51/e2a9f3b757eb802f61dc1f2b09c8c99f6eb01cf06416c0671253536517b6/blinker-1.4.tar.gz"
    sha256 "471aee25f3992bd325afa3772f1063dbdbbca947a041b8b89466dc00d606f8b6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4f/75/e1bc6e363a2c76f8d7e754c27c437dbe4086414e1d6d2f6b2a3e7846f22b/certifi-2016.9.26.tar.gz"
    sha256 "8275aef1bbeaf05c53715bfc5d8569bd1e04ca1e8e69608cc52bcaac2604eb19"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/b6/2c/66bab4fef920ef8caa3e180ea601475b2cbbe196255b18f1c58215940607/construct-2.8.8.tar.gz"
    sha256 "1b84b8147f6fd15bcf64b737c3e8ac5100811ad80c830cb4b2545140511c4157"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/82/f7/d6dfd7595910a20a563a83a762bf79a253c4df71759c3b228accb3d7e5e4/cryptography-1.7.1.tar.gz"
    sha256 "953fef7d40a49a795f4d955c5ce4338abcec5dea822ed0414ed30348303fdb4c"
  end

  resource "cssutils" do
    url "https://files.pythonhosted.org/packages/22/de/6b03e0088baf0299ab7d2e95a9e26c2092e9cb3855876b958b6a62175ca2/cssutils-1.0.1.tar.gz"
    sha256 "d8a18b2848ea1011750231f1dd64fe9053dbec1be0b37563c582561e7a529063"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/55/8a/78e165d30f0c8bb5d57c429a30ee5749825ed461ad6c959688872643ffb3/Flask-0.11.1.tar.gz"
    sha256 "b4713f2bfb9ebc2966b8a49903ae0d3984781d5c878591cf2f7b484d28756b0e"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/8e/37/4ed34cd85da66a2f77f2cba748acaaae7e681fc7381bbce647c6fb6392fc/h2-2.5.1.tar.gz"
    sha256 "673937480f97ad5a1fc8d78ff937352083c82525905b0f631db841c776a91f76"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/22/c0/2d02a1fb9027f54796af2c2d38cf3a5b89319125b03734a9964e6db8dfa0/html2text-2016.9.19.tar.gz"
    sha256 "554ef5fd6c6cf6e3e4f725a62a3e9ec86a0e4d33cd0928136d1c79dbeb7b2d55"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/d6/c0/d59bc0d311dbbc16dabd8de045e7baf53f6fb7a3cf03519efe9590a50940/hyperframe-4.0.1.tar.gz"
    sha256 "8a57365b9c5046819fb7bb9c47eb4b44fd4385b976edf3518940f11725c04e43"
  end

  resource "jsbeautifier" do
    url "https://files.pythonhosted.org/packages/e4/76/dcc8f0d76253763fb6d7035be31cb7be5f185d2877faa96759be40ef5e55/jsbeautifier-1.6.4.tar.gz"
    sha256 "c8a9c65e6c6f1a7493535f6b044491ca6230fc32d1b8392570b77c668943961c"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/46/4f/94f6165052774839b4a4af0c72071aa528d5dc8cb8bc6bb43e24a55c10cc/Pillow-3.4.2.tar.gz"
    sha256 "0ee9975c05602e755ff5000232e0335ba30d507f6261922a658ee11b1cec36d1"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/c7/9b/e09ca2fa46ad1503071a87a9398b424ceb38ec5fad689cbd235df1321d09/passlib-1.7.0.tar.gz"
    sha256 "0be4f6053357c4ebba5578a065fbdad75a844501d4c6d91d4a3a0c1594c6abed"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/38/bb/bf325351dd8ab6eb3c3b7c07c3978f38b2103e2ab48d59726916907cd6fb/pyparsing-2.1.10.tar.gz"
    sha256 "811c3e7b0031021137fc83e051795025fcb98674d07eb8fe922ba4de53d39188"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/7b/a5/48eaa1f2d77f900679e9759d2c9ab44895e66e9612f7f6b5333273b68f29/pyperclip-1.5.27.zip"
    sha256 "a3cb6df5d8f1557ca8fc514d94fabf50dc5a97042c90e5ba4f3611864fed3fc5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5b/0b/34be574b1ec997247796e5d516f3a6b6509c4e064f2885a96ed885ce7579/requests-2.12.4.tar.gz"
    sha256 "ed98431a0631e309bb4b63c81d561c1654822cb103de1ac7b47e45c26be7ae34"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/e0/f0/4eeb3183f50df3dfa9b1d931c09c98cd0ad48684407a7ee7bdc5b54360f2/ruamel.yaml-0.13.7.tar.gz"
    sha256 "f0fc12dea33b08c1d5b546857e428de98ebb9b5b2b3c5d53867582294a118aed"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/1e/7c/ea047f7bbd1ff22a7f69fe55e7561040e3e54d6f31da6267ef9748321f98/tornado-4.4.2.tar.gz"
    sha256 "2898f992f898cd41eeb8d53b6df75495f2f423b6672890aadaf196ea1448edcc"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/85/5d/9317d75b7488c335b86bd9559ca03a2a023ed3413d0e8bfe18bea76f24be/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/54/7d/c7c0ad1e32b9f132075967fc353a244eb2b375a3d2f5b0ce612fd96e107e/watchdog-0.8.3.tar.gz"
    sha256 "7e65882adb7746039b6f3876ee174952f8eaaa34491ba34333ddf1fe35de4162"
  end

  resource "brotlipy" do
    url "https://files.pythonhosted.org/packages/b0/f9/d629de68c3a9f5ce3e1ff2fe70f1cf0396765582bc3194179a2742c47731/brotlipy-0.6.0.tar.gz"
    sha256 "2680f33531ee516baf68943210a74ae5a80d3f0b88673df570d371ff53f04283"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/8d/aa/5369362d730728639ba434318df26b5c554804578d1c48381367ea5377c6/sortedcontainers-1.5.7.tar.gz"
    sha256 "0ff0442865e492bc50476b18000fb8400cf2472d14d21a92b27cd7c5184550ea"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "argh" do
    url "https://files.pythonhosted.org/packages/e3/75/1183b5d1663a66aebb2c184e0398724b624cecd4f4b679cb6e25de97ed15/argh-0.26.2.tar.gz"
    sha256 "e9535b8c84dc9571a48999094fda7f33e63c3f1b74f3e5f3ac0105a58405bb65"
  end

  resource "pathtools" do
    url "https://files.pythonhosted.org/packages/e7/7f/470d6fcdf23f9f3518f6b0b76be9df16dcc8630ad409947f8be2eb0ed13a/pathtools-0.1.2.tar.gz"
    sha256 "7c35c5421a39bb82e58018febd90e3b6e5db34c5443aaaf742b3f33d4655f1c0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "EditorConfig" do
    url "https://files.pythonhosted.org/packages/3b/c9/ea1eb869568f3dca689eb8528f9bead16f3544a38447d86dedbcd45b4e8f/EditorConfig-0.12.1.tar.gz"
    sha256 "8b53c857956194a21043753c9adca5a5b0eaef6cf1db3273a362ddec78f2b8e3"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/7b/24/3e84d3650f719b9cabc5f125c270713c2239650cdf8296dfd77485051573/hpack-2.3.0.tar.gz"
    sha256 "51bd9aa8151efd190d70fe87991b1e3b79be0f93f0e34088fba2a8d34877a0a9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/94/fe/efb1cb6f505e1a560b3d080ae6b9fddc11e7c542d694ce4635c49b1ccdcb/idna-2.2.tar.gz"
    sha256 "0ac27740937d86850010e035c6a10a564158a5accddf1aa24df89b0309252426"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/4a/4a/0e5f691c1e00d8b5678f35225cfc9e21dcebec794fb9702648b8fac716b1/Werkzeug-0.11.13.zip"
    sha256 "ebf720bc2f0ac7739ee2d6de63da8a323d73d91fddc16f5fadae915ae9e1e690"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/dc/b4/a60bcdba945c00f6d608d8975131ab3f25b22f2bcfe1dab221165194b2d4/itsdangerous-0.24.tar.gz"
    sha256 "cbb3fcf8d3e33df861709ecaf89d9e6629cff0a217bc2848f1b41cd30d360519"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  if build.with? "pyamf"
    resource "PyAMF" do
      url "https://files.pythonhosted.org/packages/a0/06/43976c0e3951b9bf7ba0d7d614a8e3e024eb5a1c6acecc9073b81c94fb52/PyAMF-0.8.0.tar.gz"
      sha256 "0455d68983e3ee49f82721132074877428d58acec52f19697a88c03b5fba74e4"
    end
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    unless MacOS::CLT.installed?
      ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/ffi" # libffi
    end

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS::CLT.installed? ? "" : MacOS.sdk_path
        s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None", "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None", "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end

      begin
        # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
        deleted = ENV.delete "SDKROOT"
        ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers" unless MacOS::CLT.installed?
        venv.pip_install Pathname.pwd
      ensure
        ENV["SDKROOT"] = deleted
      end
    end

    resource("cryptography").stage do
      if MacOS.version < :sierra
        # Fixes .../cryptography/hazmat/bindings/_openssl.so: Symbol not found: _getentropy
        # Reported 20 Dec 2016 https://github.com/pyca/cryptography/issues/3332
        inreplace "src/_cffi_src/openssl/src/osrandom_engine.h",
          "#elif defined(BSD) && defined(SYS_getentropy)",
          "#elif defined(BSD) && defined(SYS_getentropy) && 0"
      end
      venv.pip_install Pathname.pwd
    end

    res = resources.map(&:name).to_set - ["Pillow", "cryptography"]

    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/mitmproxy --version 2>&1")
  end
end
