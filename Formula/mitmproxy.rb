class Mitmproxy < Formula
  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://github.com/mitmproxy/mitmproxy/archive/v0.16.tar.gz"
  sha256 "d4ed9b27377431fc3d6241b43588279cb7e41e64a134a981938e162143c1ec72"
  head "https://github.com/mitmproxy/mitmproxy.git"

  bottle do
    cellar :any
    sha256 "8b0726d8610ce882e3eca2d1af651b36cfd15b3ab6a44ca58a016d87eb56fc3b" => :el_capitan
    sha256 "bfb490b2e2783400384f0e39adbbc13ab603c6c0c727c5e55ffa3f54cfedf651" => :yosemite
    sha256 "8ec7d893519c2820d5a0ac516c743054b81c07244413e1cdc6be92ef1baedfcd" => :mavericks
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
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-20.2.2.tar.gz"
    sha256 "24fcfc15364a9fe09a220f37d2dcedc849795e3de3e4b393ee988e66a9cbd85a"
  end

  resource "argh" do
    url "https://pypi.python.org/packages/source/a/argh/argh-0.26.1.tar.gz"
    sha256 "06a7442cb9130fb8806fe336000fcf20edf1f2f8ad205e7b62cec118505510db"
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
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.5.2.tar.gz"
    sha256 "da9bde99872e46f7bb5cff40a9b1cc08406765efafb583c704de108b6cb821dd"
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
    url "https://pypi.python.org/packages/source/c/cryptography/cryptography-1.2.3.tar.gz"
    sha256 "8eb11c77dd8e73f48df6b2f7a7e16173fe0fe8fdfe266232832e88477e08454e"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.1.2.tar.gz"
    sha256 "2475d7fcddf5951e92ff546972758802de5260bf409319a9f1934e6bbc8b1dc7"
  end

  resource "h2" do
    url "https://pypi.python.org/packages/source/h/h2/h2-2.1.3.tar.gz"
    sha256 "7d36132c42edcc19e771555e569c3f3a8610ff052e8e3d19c91b4c29a1c31e49"
  end

  resource "hpack" do
    url "https://pypi.python.org/packages/source/h/hpack/hpack-2.1.1.tar.gz"
    sha256 "17cf0750f0555447f546b4754f69c8a906a3c10a51d1884c83e41f4f3bd71f8a"
  end

  resource "html2text" do
    url "https://pypi.python.org/packages/source/h/html2text/html2text-2016.1.8.tar.gz"
    sha256 "088046f9b126761ff7e3380064d4792279766abaa5722d0dd765d011cf0bb079"
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

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-3.5.0.tar.gz"
    sha256 "349f93e3a4b09cc59418854ab8013d027d246757c51744bf20069bc89016f578"
  end

  resource "netlib" do
    url "https://pypi.python.org/packages/source/n/netlib/netlib-0.16.tar.gz"
    sha256 "c70ed1915a5662c9ffce4dc97d143209e009cf0035a2f692031a6c47e87e6002"
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
    url "https://pypi.python.org/packages/source/P/Pillow/Pillow-3.1.2.tar.gz"
    sha256 "c593622445503ae1ee361d3a6bb40794e043b43d00c96fcb298ba43ecd375905"
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
    url "https://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.15.1.tar.gz"
    sha256 "f0a26070d6db0881de8bcc7846934b7c3c930d8f9c79d45883ee48984bc0d672"
  end

  resource "pyparsing" do
    url "https://pypi.python.org/packages/source/p/pyparsing/pyparsing-2.1.1.tar.gz"
    sha256 "9bae5cd4cbee6da0d7d8d9a1647f5253a3b89652e707647eaf1961f4932ae6c6"
  end

  resource "pyperclip" do
    url "https://pypi.python.org/packages/source/p/pyperclip/pyperclip-1.5.27.zip"
    sha256 "a3cb6df5d8f1557ca8fc514d94fabf50dc5a97042c90e5ba4f3611864fed3fc5"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
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
    system bin/"mitmproxy", "--version"
  end
end
