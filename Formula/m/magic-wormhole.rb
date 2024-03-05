class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https://github.com/magic-wormhole/magic-wormhole"
  # Move completions to stable on the next release. Currently, they are only available on HEAD.
  url "https://files.pythonhosted.org/packages/cc/e1/75c31ad5db873268ba0750006b3d0e40c30b0ad39e6f58b1e28a28d6de48/magic-wormhole-0.13.0.tar.gz"
  sha256 "ac3bd68286270e7f149c06149a8e409e5fa34d7feb0e88844a26d29eed2d1516"
  license "MIT"
  revision 2
  head "https://github.com/magic-wormhole/magic-wormhole.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "3df0d518d769d706973124b81be517400b01ca377382f8e61aa5cc3eab98fd06"
    sha256 cellar: :any,                 arm64_ventura:  "15163ada341c3b4dafc8faf521e00f2ca4421a7ad77b55cff2e511bbab309dd8"
    sha256 cellar: :any,                 arm64_monterey: "01072610ec55a100e301ae3314a355827bead9a86ad164ea77d61586010dca95"
    sha256 cellar: :any,                 sonoma:         "39865379d7617ca2d32dfd3ebf7c42687f8fe1704813f21369b5466b6533c384"
    sha256 cellar: :any,                 ventura:        "314b8351d61bb269564f0cfc32423ff24e3cd974616b90fa444e714fde219e50"
    sha256 cellar: :any,                 monterey:       "27ddf3527fb50148a1b808216de4abd68cac7eddb20cef91cf0bff54604b020b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d5423442ea66f14b2de664a63b5febd32a98a6612abc667e252595d08c9dc0f"
  end

  depends_on "libsodium"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "autobahn" do
    url "https://files.pythonhosted.org/packages/92/ee/c3320c326919394ff597592549ff5d29d2f7bf12be9ddaa9017caff1a170/autobahn-23.6.2.tar.gz"
    sha256 "ec9421c52a2103364d1ef0468036e6019ee84f71721e86b36fe19ad6966c1181"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/7a/7b/9c3d26d8a0416eefbc0428f168241b32657ca260fb7ef507596ff5c2f6c4/Automat-22.10.0.tar.gz"
    sha256 "e56beb84edad19dcc11d30e8d9b895f75deeb5ef5e96b84a467066b3b84bb04e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "hkdf" do
    url "https://files.pythonhosted.org/packages/c3/be/327e072850db181ce56afd51e26ec7aa5659b18466c709fa5ea2548c935f/hkdf-0.0.3.tar.gz"
    sha256 "622a31c634bc185581530a4b44ffb731ed208acf4614f9c795bdd70e77991dca"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/76/21/7a0b24fae849562397efd79da58e62437243ae0fd0f6c09c6bc26225b75c/humanize-4.9.0.tar.gz"
    sha256 "582a265c931c683a7e9b8ed9559089dea7edcf6cc95be39a3cbc2c5d5ac2bcfa"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/86/42/9e87f04fa2cd40e3016f27a4b4572290e95899c6dce317e2cdb580f3ff09/incremental-22.10.0.tar.gz"
    sha256 "912feeb5e0f7e0188e6f42241d2f450002e11bbc0937c65865045854c24c0bd0"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ce/dc/996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7/pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/eb/81/022190e5d21344f6110064f6f52bf0c3b9da86e9e5a64fc4a884856a577d/pyOpenSSL-24.0.0.tar.gz"
    sha256 "6aa33039a93fffa4563e655b61d11364d01264be8ccb49906101e02a334530bf"
  end

  resource "service-identity" do
    url "https://files.pythonhosted.org/packages/38/d2/2ac20fd05f1b6fce31986536da4caeac51ed2e1bb25d4a7d73ca4eccdfab/service_identity-24.1.0.tar.gz"
    sha256 "6829c9d62fb832c2e1c435629b0a8c476e1929881f28bee4d20bc24161009221"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "spake2" do
    url "https://files.pythonhosted.org/packages/60/0b/bb5eca8e18c38a10b1c207bbe6103df091e5cf7b3e5fdc0efbcad7b85b60/spake2-0.8.tar.gz"
    sha256 "c17a614b29ee4126206e22181f70a406c618d3c6c62ca6d6779bce95e9c926f4"

    # Update versioneer script for 3.12. Remove when merged/released
    # https://github.com/warner/python-spake2/pull/15
    patch do
      url "https://github.com/warner/python-spake2/commit/5079cc963305c8aa6465e2a4bbbb08781fb49d3b.patch?full_index=1"
      sha256 "2e095162aeb910eb5ca399763499b414b400bcf5cf59fd851f5810d7b6d11646"
    end
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/ea/85/3ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8/tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "twisted" do
    url "https://files.pythonhosted.org/packages/6e/d3/077ece8f12cd82419bd68bb34cf4538c4df5bb9202835e7a18358223e537/twisted-23.10.0.tar.gz"
    sha256 "987847a0790a2c597197613686e2784fd54167df3a55d0fb17c8412305d76ce5"
  end

  resource "txaio" do
    url "https://files.pythonhosted.org/packages/51/91/bc9fd5aa84703f874dea27313b11fde505d343f3ef3ad702bddbe20bfd6e/txaio-23.1.1.tar.gz"
    sha256 "f9a9216e976e5e3246dfd112ad7ad55ca915606b60b84a757ac769bd404ff704"
  end

  resource "txtorcon" do
    url "https://files.pythonhosted.org/packages/39/eb/dd87610a296ac02aba6a67668e5811e43078ea32d261e0c8eb2d43d6e67c/txtorcon-23.11.0.tar.gz"
    sha256 "71f85ae93d76d726510059c9ed74e608bc5a5c9f7d103853b49e414280406a2f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b0/b4/bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97b/wheel-0.42.0.tar.gz"
    sha256 "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/cd/37/1b003190ba7148226a8212d98ff8074e212fef30c82e616bdb818ae1f838/zope.interface-6.2.tar.gz"
    sha256 "3b6c62813c63c543a06394a636978b22dffa8c5410affc9331ce6cdb5bfa8565"
  end

  def install
    # Workaround versioneer script broken on 3.12. Remove on next release.
    # https://github.com/magic-wormhole/magic-wormhole/pull/507
    inreplace "setup.py", "commands = versioneer.get_cmdclass()", "commands = {}"
    inreplace "setup.py", "version=versioneer.get_version(),", "version='#{version}',"

    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
    man1.install "docs/wormhole.1"
    if build.head?
      # Move completions to stable on the next release. Currently, they are only available on HEAD.
      bash_completion.install "wormhole_complete.bash"=> "wormhole.bash"
      fish_completion.install "wormhole_complete.fish" => "wormhole.fish"
      zsh_completion.install "wormhole_complete.zsh" => "_wormhole"
    end
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
