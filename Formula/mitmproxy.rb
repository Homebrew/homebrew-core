class Mitmproxy < Formula
  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://github.com/mitmproxy/mitmproxy/archive/v0.17.1.tar.gz"
  sha256 "5f9605f0703f03eca21173067161332eeb0e70a22a67aa3b329dc4a203f4dadc"
  head "https://github.com/mitmproxy/mitmproxy.git"

  bottle do
    cellar :any
    sha256 "68bd2c04e8ec3c03aeae475ab8ade20aacbc9c651562cd5462fbe147c769ef3f" => :sierra
    sha256 "e90d6243103cd8eec0c100ecd065c3ef2b84b75802bb81dc00821677859e5c5f" => :el_capitan
    sha256 "04072d6670530e6142e497cfc684e48142b9296f3116d36a4397fc8a1fde0d4c" => :yosemite
    sha256 "40e38f4e5c156dcbff58f23bd4c9c1ea5d766300f1e904aeb03672cff85824ba" => :mavericks
  end

  option "with-pyamf", "Enable action message format (AMF) support for python"
  option "with-cssutils", "Enable beautification of CSS responses"

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "openssl"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "protobuf" => :optional

  # needs a recent setuptools
  resource "setuptools" do
    url "https://pypi.python.org/packages/5b/6e/a4bf49ddc41f144fd511f24c096dfa7600bffaf348563e08ef381dd6323e/setuptools-21.2.2.tar.gz"
    sha256 "0792954bf85cb23cf8dc07ca2e671730badebfe7c9225889129f2427718f03c6"
  end

  resource "argh" do
    url "https://pypi.python.org/packages/e3/75/1183b5d1663a66aebb2c184e0398724b624cecd4f4b679cb6e25de97ed15/argh-0.26.2.tar.gz"
    sha256 "e9535b8c84dc9571a48999094fda7f33e63c3f1b74f3e5f3ac0105a58405bb65"
  end

  resource "backports_abc" do
    url "https://pypi.python.org/packages/source/b/backports_abc/backports_abc-0.4.tar.gz"
    sha256 "8b3e4092ba3d541c7a2f9b7d0d9c0275b21c6a01c53a61c731eba6686939d0a5"
  end

  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "blinker" do
    url "https://pypi.python.org/packages/source/b/blinker/blinker-1.4.tar.gz"
    sha256 "471aee25f3992bd325afa3772f1063dbdbbca947a041b8b89466dc00d606f8b6"
  end

  resource "certifi" do
    url "https://pypi.python.org/packages/source/c/certifi/certifi-2016.2.28.tar.gz"
    sha256 "5e8eccf95924658c97b990b50552addb64f55e1e3dfe4880456ac1f287dc79d0"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/b6/98/11feff87072e2e640fb8320712b781eccdef05d588618915236b32289d5a/cffi-1.6.0.tar.gz"
    sha256 "a7f75c4ef2362c0a0e54657add0a6c509fecbfa3b3807bc0925f5cb1c9f927db"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "ConfigArgParse" do
    url "https://pypi.python.org/packages/source/C/ConfigArgParse/ConfigArgParse-0.10.0.tar.gz"
    sha256 "3b50a83dd58149dfcee98cb6565265d10b53e9c0a2bca7eeef7fb5f5524890a7"
  end

  resource "construct" do
    url "https://pypi.python.org/packages/source/c/construct/construct-2.5.2.tar.gz"
    sha256 "665b6271eeadf15219c726b180c8d7a641d026784d72ca3dad90a20aae009020"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/04/da/35f9a1d34dab5d777f65fb87731288f338ab0ae46a525ffdf0405b573dd0/cryptography-1.3.2.tar.gz"
    sha256 "fbaafa8827966dc588ccb00be813d3149fa8de04aec96e418ea0fdd5f0312088"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/f0/0b/8a8665427c6ad17083958eb8df3987cde8206ad5c27c3ba17373316be34c/enum34-1.1.5.zip"
    sha256 "7580699f440ebc08ce51e04efd34e685264779e64bb5312112a785eac769e037"
  end

  resource "flask" do
    url "https://pypi.python.org/packages/db/9c/149ba60c47d107f85fe52564133348458f093dd5e6b57a5b60ab9ac517bb/Flask-0.10.1.tar.gz"
    sha256 "4c83829ff83d408b5e1d4995472265411d2c414112298f2eb4b359d9e4563373"
  end

  resource "h2" do
    url "https://pypi.python.org/packages/2b/d6/8252330d89fddf3fbde66ac8a449f4af6515600ce28b29d720a5fbc8a706/h2-2.3.1.tar.gz"
    sha256 "5e2416e0b228788209ee3a9bf449f5e239925b36213c34e3287ce369271a23cf"
  end

  resource "hpack" do
    url "https://pypi.python.org/packages/b6/36/d9b4d3b5802002d38cc6ce0586509ea8f24a2f256d3fa9bc23b9c50d00be/hpack-2.2.0.tar.gz"
    sha256 "f2917b3f003c7c76c1aa17e89c1fc27a80d2175d6283131890253609f5f370ef"
  end

  resource "html2text" do
    url "https://pypi.python.org/packages/85/5f/d57f91075dfb29677bcbe29376b3ed7db361db35a091b5990dca14c63681/html2text-2016.4.2.tar.gz"
    sha256 "32e5e49eb520335bae200a00e3cc981f1ade558930068e1bb2a6e3fb1504f951"
  end

  resource "hyperframe" do
    url "https://pypi.python.org/packages/source/h/hyperframe/hyperframe-3.2.0.tar.gz"
    sha256 "05f0e063e117c16fcdd13c12c93a4424a2c40668abfac3bb419a10f57698204e"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/source/i/idna/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/source/i/ipaddress/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
  end

  resource "itsdangerous" do
    url "https://pypi.python.org/packages/dc/b4/a60bcdba945c00f6d608d8975131ab3f25b22f2bcfe1dab221165194b2d4/itsdangerous-0.24.tar.gz"
    sha256 "cbb3fcf8d3e33df861709ecaf89d9e6629cff0a217bc2848f1b41cd30d360519"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "lxml" do
    url "https://pypi.python.org/packages/11/1b/fe6904151b37a0d6da6e60c13583945f8ce3eae8ebd0ec763ce546358947/lxml-3.6.0.tar.gz"
    sha256 "9c74ca28a7f0c30dca8872281b3c47705e21217c8bc63912d95c9e2a7cac6bdf"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "passlib" do
    url "https://pypi.python.org/packages/source/p/passlib/passlib-1.6.5.tar.gz"
    sha256 "a83d34f53dc9b17aa42c9a35c3fbcc5120f3fcb07f7f8721ec45e6a27be347fc"
  end

  resource "pathtools" do
    url "https://pypi.python.org/packages/source/p/pathtools/pathtools-0.1.2.tar.gz"
    sha256 "7c35c5421a39bb82e58018febd90e3b6e5db34c5443aaaf742b3f33d4655f1c0"
  end

  resource "Pillow" do
    url "https://pypi.python.org/packages/e2/af/0a3981fffc5cd43078eb8b1057702e0dd2d5771e5aaa36cbd140e32f8473/Pillow-3.2.0.tar.gz"
    sha256 "64b0a057210c480aea99406c9391180cd866fc0fd8f0b53367e3af21b195784a"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pyOpenSSL" do
    url "https://pypi.python.org/packages/77/f2/bccec75ca4280a9fa762a90a1b8b152a22eac5d9c726d7da1fcbfe0a20e6/pyOpenSSL-16.0.0.tar.gz"
    sha256 "363d10ee43d062285facf4e465f4f5163f9f702f9134f0a5896f134cbb92d17d"
  end

  resource "pyparsing" do
    url "https://pypi.python.org/packages/30/b6/12a3f337bf6eb3d681f4f83d6c8da596f99c6ce44797aa91869c1f103729/pyparsing-2.0.7.tar.gz"
    sha256 "2ce0db3c70ec0413603d4aea389e4ece34ff93c265649b1c5c7d56e3c2cf19c4"
  end

  resource "pyperclip" do
    url "https://pypi.python.org/packages/source/p/pyperclip/pyperclip-1.5.27.zip"
    sha256 "a3cb6df5d8f1557ca8fc514d94fabf50dc5a97042c90e5ba4f3611864fed3fc5"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/64/20/2133a092a0e87d1c250fe48704974b73a1341b7e4f800edecf40462a825d/requests-2.9.2.tar.gz"
    sha256 "d8be941a08cf36e4f424ac76073eb911e5e646a33fcb3402e1642c426bf34682"
  end

  resource "singledispatch" do
    url "https://pypi.python.org/packages/source/s/singledispatch/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tornado" do
    url "https://pypi.python.org/packages/source/t/tornado/tornado-4.3.tar.gz"
    sha256 "c9c2d32593d16eedf2cec1b6a41893626a2649b40b21ca9c4cac4243bde2efbf"
  end

  resource "urwid" do
    url "https://pypi.python.org/packages/source/u/urwid/urwid-1.3.1.tar.gz"
    sha256 "cfcec03e36de25a1073e2e35c2c7b0cc6969b85745715c3a025a31d9786896a1"
  end

  resource "watchdog" do
    url "https://pypi.python.org/packages/source/w/watchdog/watchdog-0.8.3.tar.gz"
    sha256 "7e65882adb7746039b6f3876ee174952f8eaaa34491ba34333ddf1fe35de4162"
  end

  resource "werkzeug" do
    url "https://pypi.python.org/packages/0f/7c/b316cd9779817173e93f5cebc8fb387db33cc8dc526f3db5e61f2c008d5b/Werkzeug-0.11.9.tar.gz"
    sha256 "837b71338794634c24713a79c3b9c287301433f2d18cd0adefcbcf885e60c8a1"
  end

  # Optional resources
  resource "PyAMF" do
    url "https://pypi.python.org/packages/source/P/PyAMF/PyAMF-0.8.0.tar.gz"
    sha256 "0455d68983e3ee49f82721132074877428d58acec52f19697a88c03b5fba74e4"
  end

  resource "cssutils" do
    url "https://pypi.python.org/packages/source/c/cssutils/cssutils-1.0.1.tar.gz"
    sha256 "d8a18b2848ea1011750231f1dd64fe9053dbec1be0b37563c582561e7a529063"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    unless MacOS::CLT.installed?
      ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/ffi" # libffi
    end

    resource("Pillow").stage do
      inreplace "setup.py", "'brew', '--prefix'", "'#{HOMEBREW_PREFIX}/bin/brew', '--prefix'"
      saved_sdkroot = ENV.delete "SDKROOT"
      begin
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      ensure
        ENV["SDKROOT"] = saved_sdkroot
      end
    end

    res = resources.map(&:name).to_set - ["Pillow"]

    res << "PyAMF" if build.with? "pyamf"
    res << "cssutils" if build.with? "cssutils"

    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/mitmproxy --version 2>&1")
  end
end
