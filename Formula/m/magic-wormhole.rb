class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https://github.com/magic-wormhole/magic-wormhole"
  url "https://files.pythonhosted.org/packages/1a/55/b82ace1c0c090bc6f629a93f3fb1ed60436731b166de2454d1585532c86f/magic-wormhole-0.16.0.tar.gz"
  sha256 "14e6c146898dbda7a6d190262623a69419955363e7e434d64aad2d233d6d94c9"
  license "MIT"
  revision 1
  head "https://github.com/magic-wormhole/magic-wormhole.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1c58015ca8577714ae98dd01ba8738e76134734d656226a441d7abfff89597d"
    sha256 cellar: :any,                 arm64_sonoma:  "1dcba47853b65ae1ebe52107c9bdfa472e1f0d893908179baeed23cc67ea27fe"
    sha256 cellar: :any,                 arm64_ventura: "461d77ee570880d2faae67111e9ec423fed0c36ec776d4cfece4d28853c18b36"
    sha256 cellar: :any,                 sonoma:        "59126c84771aed806802675d7857e90cb06731d9fe1978496725ee0f31a4e228"
    sha256 cellar: :any,                 ventura:       "bc07aa1415bfbe3a01c7612f40cb471c6911437f72f582dce146ca7ea494d77f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e47dca07a9d11ea72834d963b2dd75cdfdb8744c392829a9ef1cade5885bef3b"
  end

  depends_on "cryptography"
  depends_on "libsodium"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "autobahn" do
    url "https://files.pythonhosted.org/packages/38/f2/8dffb3b709383ba5b47628b0cc4e43e8d12d59eecbddb62cfccac2e7cf6a/autobahn-24.4.2.tar.gz"
    sha256 "a2d71ef1b0cf780b6d11f8b205fd2c7749765e65795f2ea7d823796642ee92c9"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/8d/2d/ede4ad7fc34ab4482389fa3369d304f2fa22e50770af706678f6a332fa82/automat-24.8.1.tar.gz"
    sha256 "b34227cf63f6325b8ad2399ede780675083e439b20c323d376373d8ee6306d88"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/6a/40/64a912b9330786df25e58127194d4a5a7441f818b400b155e748a270f924/humanize-4.11.0.tar.gz"
    sha256 "e66f36020a2d5a974c504bd2555cf770621dbdbb6d82f94a6857c0b1ea2608be"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/27/87/156b374ff6578062965afe30cc57627d35234369b3336cf244b240c8d8e6/incremental-24.7.2.tar.gz"
    sha256 "fb4f1d47ee60efe87d4f6f0ebb5f70b9760db2b2574c59c8e8912be4ebd464c9"
  end

  resource "iterable-io" do
    url "https://files.pythonhosted.org/packages/40/be/27d59b5c1d74ecbd26c1142f84b61d6cb04f0d0337697149645f34406b2d/iterable-io-1.0.0.tar.gz"
    sha256 "fb9e1b739587a9ba0d5c60a3e1eb71246761583bc9f18b3c35bb112b44b18c3c"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/1d/67/6afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9/pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/5d/70/ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8/pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "service-identity" do
    url "https://files.pythonhosted.org/packages/38/d2/2ac20fd05f1b6fce31986536da4caeac51ed2e1bb25d4a7d73ca4eccdfab/service_identity-24.1.0.tar.gz"
    sha256 "6829c9d62fb832c2e1c435629b0a8c476e1929881f28bee4d20bc24161009221"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "spake2" do
    url "https://files.pythonhosted.org/packages/c5/4b/32ad65f8ff5c49254e218ccaae8fc16900cfc289954fb372686159ebe315/spake2-0.9.tar.gz"
    sha256 "421fc4a8d5ac395af7af0206ffd9e6cdf188c105cb1b883d9d683312bb5a9334"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/58/83/6ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5/tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "twisted" do
    url "https://files.pythonhosted.org/packages/8b/bf/f30eb89bcd14a21a36b4cd3d96658432d4c590af3c24bbe08ea77fa7bbbb/twisted-24.7.0.tar.gz"
    sha256 "5a60147f044187a127ec7da96d170d49bcce50c6fd36f594e60f4587eff4d394"
  end

  resource "txaio" do
    url "https://files.pythonhosted.org/packages/51/91/bc9fd5aa84703f874dea27313b11fde505d343f3ef3ad702bddbe20bfd6e/txaio-23.1.1.tar.gz"
    sha256 "f9a9216e976e5e3246dfd112ad7ad55ca915606b60b84a757ac769bd404ff704"
  end

  resource "txtorcon" do
    url "https://files.pythonhosted.org/packages/b9/9f/7815b07d8bc775d9578d9131267bb7ce3e91e31305688736ed796ae724d1/txtorcon-24.8.0.tar.gz"
    sha256 "befe19138d9c8c5307b6ee6d4fe446d0c201ffd1cc404aeb265ed90309978ad0"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "zipstream-ng" do
    url "https://files.pythonhosted.org/packages/74/8c/682c8bb3085d2089e09c0b9393a12721d059dc0009da4e0b6faff6370679/zipstream-ng-1.7.1.tar.gz"
    sha256 "f92023b9ca578cd7fdd94ec733c65664ecf7ee32493e38cdf8e365a1316e9ffc"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/c8/83/7de03efae7fc9a4ec64301d86e29a324f32fe395022e3a5b1a79e376668e/zope.interface-7.0.3.tar.gz"
    sha256 "cd2690d4b08ec9eaf47a85914fe513062b20da78d10d6d789a792c0b20307fb1"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
    man1.install "docs/wormhole.1"
    bash_completion.install "wormhole_complete.bash"=> "wormhole.bash"
    fish_completion.install "wormhole_complete.fish" => "wormhole.fish"
    zsh_completion.install "wormhole_complete.zsh" => "_wormhole"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    n = rand(1e6)
    pid = fork do
      exec bin/"wormhole", "send", "--code=#{n}-homebrew-test", "--text=foo"
    end
    sleep 1
    begin
      received = shell_output("#{bin}/wormhole receive #{n}-homebrew-test")
      assert_match received, "foo\n"
    ensure
      Process.wait(pid)
    end
  end
end
