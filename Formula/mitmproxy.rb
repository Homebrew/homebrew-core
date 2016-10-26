class Mitmproxy < Formula
  include Language::Python::Virtualenv

  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://github.com/mitmproxy/mitmproxy/archive/v0.18.2.tar.gz"
  sha256 "01dc931fc251ded20265ef454227c9798ba3f1d53abe7140d9c1990694b4c172"
  head "https://github.com/mitmproxy/mitmproxy.git"

  bottle do
    sha256 "0f150a1aba0f617633010f655b03c4020fc1e33ecdced12b2f937a6271baf632" => :sierra
    sha256 "3d2e4cd27d2b9810079fc7cc848378ef0e623327caf20d88e7500a0dbd265944" => :el_capitan
    sha256 "57e6d62669498ca1c1a8208e1ba792b126d37eeb6fad6b50e0ede710b0390229" => :yosemite
  end

  option "with-pyamf", "Enable action message format (AMF) support for python"

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "openssl"
  depends_on :python
  depends_on "protobuf" => :optional

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/55/8a/78e165d30f0c8bb5d57c429a30ee5749825ed461ad6c959688872643ffb3/Flask-0.11.1.tar.gz"
    sha256 "b4713f2bfb9ebc2966b8a49903ae0d3984781d5c878591cf2f7b484d28756b0e"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/46/4f/94f6165052774839b4a4af0c72071aa528d5dc8cb8bc6bb43e24a55c10cc/Pillow-3.4.2.tar.gz"
    sha256 "0ee9975c05602e755ff5000232e0335ba30d507f6261922a658ee11b1cec36d1"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/43/2e/d822b4a4216804519ace92e0368dcfc4b0b2887462d852fdd476b253ecc9/Werkzeug-0.11.11.tar.gz"
    sha256 "e72c46bc14405cba7a26bd2ce28df734471bc9016bc8b4cb69466c2c14c2f7e5"
  end

  resource "argh" do
    url "https://files.pythonhosted.org/packages/e3/75/1183b5d1663a66aebb2c184e0398724b624cecd4f4b679cb6e25de97ed15/argh-0.26.2.tar.gz"
    sha256 "e9535b8c84dc9571a48999094fda7f33e63c3f1b74f3e5f3ac0105a58405bb65"
  end

  resource "backports_abc" do
    url "https://files.pythonhosted.org/packages/f5/d0/1d02695c0dd4f0cf01a35c03087c22338a4f72e24e2865791ebdb7a45eac/backports_abc-0.4.tar.gz"
    sha256 "8b3e4092ba3d541c7a2f9b7d0d9c0275b21c6a01c53a61c731eba6686939d0a5"
  end

  resource "backports.ssl_match_hostname" do
    url "https://files.pythonhosted.org/packages/76/21/2dc61178a2038a5cb35d14b61467c6ac632791ed05131dda72c20e7b9e23/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1b/51/e2a9f3b757eb802f61dc1f2b09c8c99f6eb01cf06416c0671253536517b6/blinker-1.4.tar.gz"
    sha256 "471aee25f3992bd325afa3772f1063dbdbbca947a041b8b89466dc00d606f8b6"
  end

  resource "brotlipy" do
    url "https://files.pythonhosted.org/packages/b0/f9/d629de68c3a9f5ce3e1ff2fe70f1cf0396765582bc3194179a2742c47731/brotlipy-0.6.0.tar.gz"
    sha256 "2680f33531ee516baf68943210a74ae5a80d3f0b88673df570d371ff53f04283"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4f/75/e1bc6e363a2c76f8d7e754c27c437dbe4086414e1d6d2f6b2a3e7846f22b/certifi-2016.9.26.tar.gz"
    sha256 "8275aef1bbeaf05c53715bfc5d8569bd1e04ca1e8e69608cc52bcaac2604eb19"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/0a/f3/686af8873b70028fccf67b15c78fd4e4667a3da995007afc71e786d61b0a/cffi-1.8.3.tar.gz"
    sha256 "c321bd46faa7847261b89c0469569530cad5a41976bb6dba8202c0159f476568"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/45/87/a815edcdc867de0964e5f1efef6db956bbb6fe77dbe3f273f2aeab39cbe8/ConfigArgParse-0.11.0.tar.gz"
    sha256 "6c8ae823f6844b055f2a3aa9b51f568ed3bd7e5be9fba63abcaf4bdd38a0ac89"
  end

  # construct<2.6,>=2.5.2
  resource "construct" do
    url "https://files.pythonhosted.org/packages/bc/e8/8db5c4d4e4afda5e12a50ba72144e888635aeb329be55806461f6af19bbe/construct-2.5.5-reupload.tar.gz"
    sha256 "6eef7869dca32dabee1797350e3161e8f073ecac9fc0cf36f9264a941c107111"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/03/1a/60984cb85cc38c4ebdfca27b32a6df6f1914959d8790f5a349608c78be61/cryptography-1.5.2.tar.gz"
    sha256 "eb8875736734e8e870b09be43b17f40472dc189b1c422a952fa8580768204832"
  end

  resource "cssutils" do
    url "https://files.pythonhosted.org/packages/22/de/6b03e0088baf0299ab7d2e95a9e26c2092e9cb3855876b958b6a62175ca2/cssutils-1.0.1.tar.gz"
    sha256 "d8a18b2848ea1011750231f1dd64fe9053dbec1be0b37563c582561e7a529063"
  end

  resource "EditorConfig" do
    url "https://files.pythonhosted.org/packages/3b/c9/ea1eb869568f3dca689eb8528f9bead16f3544a38447d86dedbcd45b4e8f/EditorConfig-0.12.1.tar.gz"
    sha256 "8b53c857956194a21043753c9adca5a5b0eaef6cf1db3273a362ddec78f2b8e3"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/f7/59/3edbec0c7da126e8e474fc6ba96e88e2e4fa475b38d3506d282f85da883f/h2-2.4.2.tar.gz"
    sha256 "e47d8e32d35e5678be7c49bbb3ce3d335dd4e22954292b6f3370a64f8b820284"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/7b/24/3e84d3650f719b9cabc5f125c270713c2239650cdf8296dfd77485051573/hpack-2.3.0.tar.gz"
    sha256 "51bd9aa8151efd190d70fe87991b1e3b79be0f93f0e34088fba2a8d34877a0a9"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/22/c0/2d02a1fb9027f54796af2c2d38cf3a5b89319125b03734a9964e6db8dfa0/html2text-2016.9.19.tar.gz"
    sha256 "554ef5fd6c6cf6e3e4f725a62a3e9ec86a0e4d33cd0928136d1c79dbeb7b2d55"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/d6/c0/d59bc0d311dbbc16dabd8de045e7baf53f6fb7a3cf03519efe9590a50940/hyperframe-4.0.1.tar.gz"
    sha256 "8a57365b9c5046819fb7bb9c47eb4b44fd4385b976edf3518940f11725c04e43"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/bb/26/3b64955ff73f9e3155079b9ed31812afdfa5333b5c76387454d651ef593a/ipaddress-1.0.17.tar.gz"
    sha256 "3a21c5a15f433710aaa26f1ae174b615973a25182006ae7f9c26de151cd51716"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/dc/b4/a60bcdba945c00f6d608d8975131ab3f25b22f2bcfe1dab221165194b2d4/itsdangerous-0.24.tar.gz"
    sha256 "cbb3fcf8d3e33df861709ecaf89d9e6629cff0a217bc2848f1b41cd30d360519"
  end

  resource "jsbeautifier" do
    url "https://files.pythonhosted.org/packages/e4/76/dcc8f0d76253763fb6d7035be31cb7be5f185d2877faa96759be40ef5e55/jsbeautifier-1.6.4.tar.gz"
    sha256 "c8a9c65e6c6f1a7493535f6b044491ca6230fc32d1b8392570b77c668943961c"
  end

  # lxml<=3.6.0,>=3.5.0
  resource "lxml" do
    url "https://files.pythonhosted.org/packages/11/1b/fe6904151b37a0d6da6e60c13583945f8ce3eae8ebd0ec763ce546358947/lxml-3.6.0.tar.gz"
    sha256 "9c74ca28a7f0c30dca8872281b3c47705e21217c8bc63912d95c9e2a7cac6bdf"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/1e/59/d1a50836b29c87a1bde9442e1846aa11e1548491cbee719e51b45a623e75/passlib-1.6.5.tar.gz"
    sha256 "a83d34f53dc9b17aa42c9a35c3fbcc5120f3fcb07f7f8721ec45e6a27be347fc"
  end

  resource "pathtools" do
    url "https://files.pythonhosted.org/packages/e7/7f/470d6fcdf23f9f3518f6b0b76be9df16dcc8630ad409947f8be2eb0ed13a/pathtools-0.1.2.tar.gz"
    sha256 "7c35c5421a39bb82e58018febd90e3b6e5db34c5443aaaf742b3f33d4655f1c0"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  # required by cffi
  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/eb/83/00c55ff5cb773a78e9e47476ac1a0cd2f0fb71b34cb6e178572eaec22984/pycparser-2.16.tar.gz"
    sha256 "108f9ff23869ae2f8b38e481e7b4b4d4de1e32be968f29bbe303d629c34a6260"
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
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "singledispatch" do
    url "https://files.pythonhosted.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/1e/7c/ea047f7bbd1ff22a7f69fe55e7561040e3e54d6f31da6267ef9748321f98/tornado-4.4.2.tar.gz"
    sha256 "2898f992f898cd41eeb8d53b6df75495f2f423b6672890aadaf196ea1448edcc"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/19/2f/b1090ace275335a9c0dde9a4623b109b7960a2b5370ae59d1eb1539afd8a/typing-3.5.2.2.tar.gz"
    sha256 "2bce34292653af712963c877f3085250a336738e64f99048d1b8509bebc4772f"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/85/5d/9317d75b7488c335b86bd9559ca03a2a023ed3413d0e8bfe18bea76f24be/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/54/7d/c7c0ad1e32b9f132075967fc353a244eb2b375a3d2f5b0ce612fd96e107e/watchdog-0.8.3.tar.gz"
    sha256 "7e65882adb7746039b6f3876ee174952f8eaaa34491ba34333ddf1fe35de4162"
  end

  if build.with? "pyamf"
    resource "PyAMF" do
      url "https://files.pythonhosted.org/packages/a0/06/43976c0e3951b9bf7ba0d7d614a8e3e024eb5a1c6acecc9073b81c94fb52/PyAMF-0.8.0.tar.gz"
      sha256 "0455d68983e3ee49f82721132074877428d58acec52f19697a88c03b5fba74e4"
    end
  end

  def install
    venv = virtualenv_create(libexec)

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

      # avoid triggering "helpful" distutils code that doesn't recognize Xcode 7 .tbd stubs
      ENV.delete "SDKROOT"
      ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers" unless MacOS::CLT.installed?
      venv.pip_install Pathname.pwd
    end

    res = resources.map(&:name).to_set - ["Pillow"]

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
