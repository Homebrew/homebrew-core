class Copyparty < Formula
  include Language::Python::Virtualenv

  desc "Portable file server"
  homepage "https://github.com/9001/copyparty"
  url "https://files.pythonhosted.org/packages/c9/bb/941ba833b3907f32cca56ee2ccf253f664c353fe4a227f86eeea4226e817/copyparty-1.20.28.tar.gz"
  sha256 "642c6c46ce3bc268fb188504cd8019946c34d0b06913d4be5316fb8aa857b448"
  license "MIT"

  bottle do
    manifest_sha256 "02fb12c96ba7f4d1a108caf32527d20820d38b265145aa3ed3d32a8737348e3b"
    sha256 cellar: :any, arm64_golden_gate: "5be11ab53a1d5b824c1c92da1088cb2b98d7766ee7a9afac797c7531a763a0ad"
    sha256 cellar: :any, arm64_tahoe:       "ba83a85f41d894d567ad60a0e8f0f72decc4050f50b02a49d5bf79d7ffb42aaa"
    sha256 cellar: :any, arm64_sequoia:     "f05a711e7245891e62da93cef82385f4bf5bbb5628afe49f04bcefc2b429aebd"
    sha256 cellar: :any, arm64_linux:       "e19792ec593d16733a05f3b744d2828fd11a21245630a0ca7b278bb5b7bb0fb0"
    sha256 cellar: :any, x86_64_linux:      "5197d33ecd0446fc8bb06b0aff963fea194f2fdd498eb01dd9d5729c7ab49eed"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.15"
  depends_on "zeromq"

  on_macos do
    depends_on "gettext"
  end

  # "all" intentionally excludes features that ffmpeg can provide:
  # https://github.com/9001/copyparty/issues/398#issuecomment-3145365906
  pypi_packages package_name:     "copyparty[all]",
                exclude_packages: %w[cffi cryptography pillow pycparser]

  resource "argon2-cffi" do
    url "https://files.pythonhosted.org/packages/0e/89/ce5af8a7d472a67cc819d5d998aa8c82c5d860608c4db9f46f1162d7dab9/argon2_cffi-25.1.0.tar.gz"
    sha256 "694ae5cc8a42f4c4e2bf2ca0e64e51e23a040c6a517a85074683d3959e1346c1"
  end

  resource "argon2-cffi-bindings" do
    url "https://files.pythonhosted.org/packages/76/3b/f7bd1daac24c7017b6d09d05c56bb3f71aaae76b2ac4234ed2c00e0dd2d2/argon2_cffi_bindings-26.2.0.tar.gz"
    sha256 "f21ab89bb9850f32b9ca038d9961424bb0d3669d579cbbbfed068cffa6fc0643"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/33/f6/227c48c5fe47fa178ccf1fda8f047d16c97ba926567b661e9ce2045c600c/invoke-3.0.3.tar.gz"
    sha256 "437b6a622223824380bfb4e64f612711a6b648c795f565efc8625af66fb57f0c"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/76/cb/b1fde76618d84b1acf54d3d03d2b833ba5878afd12b9899346cc080f209d/paramiko-5.1.0.tar.gz"
    sha256 "239b5f9b2a53006cd54f83cf8495ee742083708ead947882c8dd2786de79f39b"
  end

  resource "partftpy" do
    url "https://files.pythonhosted.org/packages/8c/96/642bb3ddcb07a2c6764eb29aa562d1cf56877ad6c330c3c8921a5f05606d/partftpy-0.4.0.tar.gz"
    sha256 "e50db3cae27cf763c66666fe61783464f5bf0caf110cbd6e1348f91cf77859ed"
  end

  resource "pyasynchat" do
    url "https://files.pythonhosted.org/packages/ec/d2/b41df9021c12ca314146abcde7bdd3d9d37d44cc01559d7f13df459ee586/pyasynchat-1.0.5.tar.gz"
    sha256 "36665473ae730dac51e6d7dad70f8295962120c830ab692f0a31efba32687e24"
  end

  resource "pyasyncore" do
    url "https://files.pythonhosted.org/packages/4e/43/035dfe0cb01687c1940fdc008f46a43c41067e226e862df49327469764a0/pyasyncore-1.0.5.tar.gz"
    sha256 "dd483d5103a6d59b66b86e0ca2334ad43dca732ff23a0ac5d63c88c52510542e"
  end

  resource "pyftpdlib" do
    url "https://files.pythonhosted.org/packages/f9/42/8751c5f58ae59b09e070da4fa322ae9693a340d2cc456b5a380b2c1ee47a/pyftpdlib-2.2.0.tar.gz"
    sha256 "4ba0642078792df63dd3b2e9c8f838f2a3ecf428c7518d5921c0530d53512acf"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/3f/e8/7325d258199b159eb2c03fe32107533e2832e70e63f4fb88a6aa00023201/pyopenssl-26.4.0.tar.gz"
    sha256 "28dfcce0162b9211413e26dfbfdf1d24317fbeba18fc93c12400a1856b2a0bc7"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/e2/e1/ea46ab0d707219c098065a37d2add5b53d3b124241aa19429bcd0863e5b4/pyzmq-27.3.0.tar.gz"
    sha256 "bbedb3d1d99babc625f1dd9d7438acefd442b36b75073fd6bc1ef7c0a4b96d56"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      If you need to generate thumbnails for video/audio files:
        brew install ffmpeg
      If you need to automatically create a CA and server-cert on startup:
        brew install cfssl
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/copyparty --version")

    (testpath/"testfile").write "homebrew"
    logfile = testpath/"log.txt"
    port = free_port

    with_test_process(bin/"copyparty", "-q", "-p", port.to_s, "-lo", logfile) do
      output = shell_output("curl --silent --retry 5 --retry-connrefused 'localhost:#{port}?ls=t'")
      assert_match " 8  testfile", output
    end

    assert_path_exists logfile
    assert_match "listening @ [::]:#{port}", logfile.read
  end
end
