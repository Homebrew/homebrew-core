class Copyparty < Formula
  include Language::Python::Virtualenv

  desc "Portable file server"
  homepage "https://github.com/9001/copyparty"
  url "https://files.pythonhosted.org/packages/4f/0e/81965fdccef8dbd6d0ab22c421df3bc50e0bb27a5b8eaa79f046f208a4e1/copyparty-1.20.14.tar.gz"
  sha256 "a662935f75eb67232b16624621886325b26afeb0b860af506ad6f3ff2af161c6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb8bfce531f634c9b3249169fb619193069732fb380a7bfadd8c094a81c1fed4"
    sha256 cellar: :any,                 arm64_sequoia: "465d33ff72ec9cf44801aafb8d207391401e7ad410e90c957a4b7b8dc5e6e074"
    sha256 cellar: :any,                 arm64_sonoma:  "90a40ae90b848e9cff930386eef4b569fbf2fb86ea509b6072d9634907919dcb"
    sha256 cellar: :any,                 sonoma:        "4ed174a22c750a2772c6a40701a8bda95a863d54026c61fd5c34c4ec4a129c14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d42a2d11b0571eb14b6d8ef5ed66255811baa3ece606f95b4124681f52a16fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c1530966be35100f15fa51a63b9bfda1dceb5d59782eaf42c8902d0a0fdd39c"
  end

  # `pkgconf` and `rust` are for bcrypt
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium"
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"
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
    url "https://files.pythonhosted.org/packages/5c/2d/db8af0df73c1cf454f71b2bbe5e356b8c1f8041c979f505b3d3186e520a9/argon2_cffi_bindings-25.1.0.tar.gz"
    sha256 "b957f3e6ea4d55d820e40ff76f450952807013d361a65d7f28acc0acbf29229d"
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
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1f/e7/81fdcbc7f190cdb058cffc9431587eb289833bdd633e2002455ca9bb13d4/paramiko-4.0.0.tar.gz"
    sha256 "6a25f07b380cc9c9a88d2b920ad37167ac4667f8d9886ccebd8f90f654b5d69f"
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
    url "https://files.pythonhosted.org/packages/8c/a8/26d36401e3ab8eed9030ad33f381da7856fcfad5691780fccd1b019718fc/pyopenssl-26.1.0.tar.gz"
    sha256 "737f0a2275c5bc54f3b02137687e1a765931fb3949b9a92a825e4d33b9eec08b"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/04/0b/3c9baedbdf613ecaa7aa07027780b8867f57b6293b6ee50de316c9f3222b/pyzmq-27.1.0.tar.gz"
    sha256 "ac0765e3d44455adb6ddbf4417dcce460fc40a05978c08efdf2948072f6db540"
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
    pid = spawn(bin/"copyparty", "-q", "-p", port.to_s, "-lo", logfile)

    begin
      output = shell_output("curl --silent --retry 5 --retry-connrefused 'localhost:#{port}?ls=t'")
      assert_match " 8  testfile", output
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end

    assert_path_exists logfile
    assert_match "listening @ [::]:#{port}", logfile.read
  end
end
