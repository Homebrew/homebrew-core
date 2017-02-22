class Mitmproxy < Formula
  include Language::Python::Virtualenv

  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://github.com/mitmproxy/mitmproxy/archive/v2.0.0.tar.gz"
  sha256 "713a7a8967dcd7371fb0f6b417b8bd90b311c625bb4aeff3b5b59585ec196629"
  head "https://github.com/mitmproxy/mitmproxy.git"

  bottle do
    sha256 "448730823d8ea2239fc54116a36530c72d380b1db3811907972082ee4731748c" => :sierra
    sha256 "f3bf1918244725c2dd35f0229beff4db21b4ad998c68e2f465baf214542e78a9" => :el_capitan
    sha256 "2353214d573645ea2b89986d4b243f0d5d01d75f4cc3eb16d27d734d4fcdbd8b" => :yosemite
  end

  depends_on "openssl@1.1"
  depends_on :python3
  depends_on "protobuf"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/bd/66/0a7f48a0f3fb1d3a4072bceb5bbd78b1a6de4d801fb7135578e7c7b1f563/appdirs-1.4.0.tar.gz"
    sha256 "8fc245efb4387a4e3e0ac8ebcc704582df7d72ff6a42a53f5600bbb18fdaadc5"
  end

  resource "argh" do
    url "https://files.pythonhosted.org/packages/e3/75/1183b5d1663a66aebb2c184e0398724b624cecd4f4b679cb6e25de97ed15/argh-0.26.2.tar.gz"
    sha256 "e9535b8c84dc9571a48999094fda7f33e63c3f1b74f3e5f3ac0105a58405bb65"
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
    url "https://files.pythonhosted.org/packages/b6/fa/ca682d5ace0700008d246664e50db8d095d23750bb212c0086305450c276/certifi-2017.1.23.tar.gz"
    sha256 "81877fb7ac126e9215dfb15bfef7115fdc30e798e0013065158eed0707fd99ce"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/b6/2c/66bab4fef920ef8caa3e180ea601475b2cbbe196255b18f1c58215940607/construct-2.8.8.tar.gz"
    sha256 "1b84b8147f6fd15bcf64b737c3e8ac5100811ad80c830cb4b2545140511c4157"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/99/df/71c7260003f5c469cec3db4c547115df39e9ce6c719a99e067ba0e78fd8a/cryptography-1.7.2.tar.gz"
    sha256 "878cb68b3da3d493ffd68f36db11c29deee623671d3287c3f8d685117ffda9a9"
  end

  resource "cssutils" do
    url "https://files.pythonhosted.org/packages/22/de/6b03e0088baf0299ab7d2e95a9e26c2092e9cb3855876b958b6a62175ca2/cssutils-1.0.1.tar.gz"
    sha256 "d8a18b2848ea1011750231f1dd64fe9053dbec1be0b37563c582561e7a529063"
  end

  resource "EditorConfig" do
    url "https://files.pythonhosted.org/packages/3b/c9/ea1eb869568f3dca689eb8528f9bead16f3544a38447d86dedbcd45b4e8f/EditorConfig-0.12.1.tar.gz"
    sha256 "8b53c857956194a21043753c9adca5a5b0eaef6cf1db3273a362ddec78f2b8e3"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/f7/5f/7fe21818f0a4d6ef25f1396be5863c317ddaae6b8c3b430b20ca3002a225/h2-2.5.2.tar.gz"
    sha256 "85e70d89c5ef8a772f049d589aa268cf3cb813897006c22006441fbded59740f"
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
    url "https://files.pythonhosted.org/packages/6e/c5/f91cc64f742ea3d2c4d20d26abfbfe76d64fa2ff6f6228a1f9d41176a385/hyperframe-4.0.2.tar.gz"
    sha256 "12e0336997f564135ff5e1a3c667fad6fa2e8faa3ba7397352dabb2fc1871033"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/94/fe/efb1cb6f505e1a560b3d080ae6b9fddc11e7c542d694ce4635c49b1ccdcb/idna-2.2.tar.gz"
    sha256 "0ac27740937d86850010e035c6a10a564158a5accddf1aa24df89b0309252426"
  end

  resource "jsbeautifier" do
    url "https://files.pythonhosted.org/packages/84/e5/41d839a881aee07a7915912f87a22ed20926dc699a6ec158201f93b50fe2/jsbeautifier-1.6.10.tar.gz"
    sha256 "ca3e5f49bfab2933a6c68025f5d39f117f391d27a666bd100770268854019521"
  end

  resource "kaitaistruct" do
    url "https://files.pythonhosted.org/packages/42/34/25ce58b9a60ffba606f43156b14f02b0a55e88d0889abf93a20e731d7486/kaitaistruct-0.6.tar.gz"
    sha256 "22643b53f6525aaf340ce5c3152e0fe72e91c853170d85afaf7c09773ecd8c67"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/25/4b/6fbfc66aabb3017cd8c3bd97b37f769d7503ead2899bf76e570eb91270de/passlib-1.7.1.tar.gz"
    sha256 "3d948f64138c25633613f303bcc471126eae67c04d5e3f6b7b8ce6242f8653e0"
  end

  resource "pathtools" do
    url "https://files.pythonhosted.org/packages/e7/7f/470d6fcdf23f9f3518f6b0b76be9df16dcc8630ad409947f8be2eb0ed13a/pathtools-0.1.2.tar.gz"
    sha256 "7c35c5421a39bb82e58018febd90e3b6e5db34c5443aaaf742b3f33d4655f1c0"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/57/f7/c18a86169bb9995a69195177b23e736776b347fd92592da0c3cac9f1a724/pyasn1-0.2.2.tar.gz"
    sha256 "6b42f96b942406712e0be5ea2bbbc57d8f30c7835a4904c9c195cc669736d435"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
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

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/16/09/37b69de7c924d318e51ece1c4ceb679bf93be9d05973bb30c35babd596e2/requests-2.13.0.tar.gz"
    sha256 "5722cd09762faa01276230270ff16af7acf7c5c45d623868d9ba116f15791ce8"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/6d/00/061d150591d34065748857580735c4b42879a7dd3ebb75dde23671b60c26/ruamel.yaml-0.13.14.tar.gz"
    sha256 "48c41396e8f4af1d9d430fb71ca0b77e4910a45be25a9f76dc112d785e609a95"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/8d/aa/5369362d730728639ba434318df26b5c554804578d1c48381367ea5377c6/sortedcontainers-1.5.7.tar.gz"
    sha256 "0ff0442865e492bc50476b18000fb8400cf2472d14d21a92b27cd7c5184550ea"
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

  def install
    venv = virtualenv_create(libexec, "python3")

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

    res = resources.map(&:name).to_set - ["cryptography"]

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
