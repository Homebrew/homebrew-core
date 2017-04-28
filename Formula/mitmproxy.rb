class Mitmproxy < Formula
  include Language::Python::Virtualenv

  desc "Intercept, modify, replay, save HTTP/S traffic"
  homepage "https://mitmproxy.org"
  url "https://github.com/mitmproxy/mitmproxy/archive/v2.0.2.tar.gz"
  sha256 "42e8cbcd27b85e60a165d1a28692098181813bbd9d7731a42b2cda68824c6c9d"
  head "https://github.com/mitmproxy/mitmproxy.git"

  bottle do
    sha256 "0ddd7494a065cc6296fff9ea88a532c9f9e175bca54d0f0968ace3223d5bd892" => :sierra
    sha256 "6375b4fb18c3e84d53296afcce7e70f9e6bec1ed346819e333058054039b0a88" => :el_capitan
    sha256 "2763f78f8e81c1dcde3e4e99a07dd5183faf9b816870c9384debe6929a39c466" => :yosemite
  end

  depends_on "openssl@1.1"
  depends_on :python3
  depends_on "protobuf"

  resource "EditorConfig" do
    url "https://files.pythonhosted.org/packages/3b/c9/ea1eb869568f3dca689eb8528f9bead16f3544a38447d86dedbcd45b4e8f/EditorConfig-0.12.1.tar.gz"
    sha256 "8b53c857956194a21043753c9adca5a5b0eaef6cf1db3273a362ddec78f2b8e3"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "argh" do
    url "https://files.pythonhosted.org/packages/e3/75/1183b5d1663a66aebb2c184e0398724b624cecd4f4b679cb6e25de97ed15/argh-0.26.2.tar.gz"
    sha256 "e9535b8c84dc9571a48999094fda7f33e63c3f1b74f3e5f3ac0105a58405bb65"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/67/14/5d66588868c4304f804ebaff9397255f6ec5559e46724c2496e0f26e68d6/asn1crypto-0.22.0.tar.gz"
    sha256 "cbbadd640d3165ab24b06ef25d1dca09a3441611ac15f6a6b452474fdf0aed1a"
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
    url "https://files.pythonhosted.org/packages/dd/0e/1e3b58c861d40a9ca2d7ea4ccf47271d4456ae4294c5998ad817bd1b4396/certifi-2017.4.17.tar.gz"
    sha256 "f7527ebf7461582ce95f7a9e03dd141ce810d40590834f4ec20cddd54234c10a"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/5b/b9/790f8eafcdab455bcd3bd908161f802c9ce5adbf702a83aa7712fcc345b7/cffi-1.10.0.tar.gz"
    sha256 "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/b5/78/3a49752baea1578019384a873adbec5782ab13ea71d066781a0c9c5d1e38/construct-2.8.12.tar.gz"
    sha256 "67ee2c69a11bdadc0705c7e0de0ff16ef74b730932537e22ac1f64f479240ffa"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/5f/d5bc241d06665eed93cd8d3aa7198024ce7833af7a67f6dc92df94e00588/cryptography-1.8.1.tar.gz"
    sha256 "323524312bb467565ebca7e50c8ae5e9674e544951d28a2904a50012a8828190"
  end

  resource "cssutils" do
    url "https://files.pythonhosted.org/packages/5c/0b/c5f29d29c037e97043770b5e7c740b6252993e4b57f029b3cd03c78ddfec/cssutils-1.0.2.tar.gz"
    sha256 "a2fcf06467553038e98fea9cfe36af2bf14063eb147a70958cfcaa8f5786acaf"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/c9/ad/73a6c1a40eadbf9eef93fe16285a366c834cbd61783c30e6c23ef4b11e53/h2-2.6.2.tar.gz"
    sha256 "af35878673c83a44afbc12b13ac91a489da2819b5dc1e11768f3c2406f740fe9"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/44/f1/b4440e46e265a29c0cb7b09b6daec6edf93c79eae713cfed93fbbf8716c5/hpack-3.0.0.tar.gz"
    sha256 "8eec9c1f4bfae3408a3f30500261f7e6a65912dc138526ea054f9ad98892e9d2"
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
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "jsbeautifier" do
    url "https://files.pythonhosted.org/packages/f1/56/dbe9134fa145210dd89937147ac6eef584d91f0486de2afa85dcf48f4523/jsbeautifier-1.6.12.tar.gz"
    sha256 "64a8f205c9cfd7e30888ed4da23237dcee9c300c871df84463ea2bb251495f5d"
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

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/69/17/eec927b7604d2663fef82204578a0056e11e0fc08d485fdb3b6199d9b590/pyasn1-0.2.3.tar.gz"
    sha256 "738c4ebd88a718e700ee35c8d129acce2286542daa80a82823a7073644f706ad"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/7b/a5/48eaa1f2d77f900679e9759d2c9ab44895e66e9612f7f6b5333273b68f29/pyperclip-1.5.27.zip"
    sha256 "a3cb6df5d8f1557ca8fc514d94fabf50dc5a97042c90e5ba4f3611864fed3fc5"
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
    url "https://files.pythonhosted.org/packages/5c/0b/2e5cef0d30811532b27ece726fb66a41f63344af8b693c90cec9474d9022/tornado-4.4.3.tar.gz"
    sha256 "f267acc96d5cf3df0fd8a7bfb5a91c2eb4ec81d5962d1a7386ceb34c655634a8"
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
    venv.pip_install resources
    venv.pip_install_and_link buildpath
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/mitmproxy --version 2>&1")
  end
end
