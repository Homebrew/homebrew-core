class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://black.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/62/b6/82269f88c3e7855f058706a5b326b827699a3c88c96b37d9abfb81e2c62b/black-21.10b0.tar.gz"
  sha256 "a9952229092e325fe5f3dae56d81f639b23f7131eb840781947e4b2886030f33"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/black[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7bb8fb6e56445d0844d12b24d06fc4dbaa3853ce4c74d15aa8fc82f5428459d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b20596ed4e701905a576dd211d6a84f00b760119aa45eb96e0b21246508cc80"
    sha256 cellar: :any_skip_relocation, monterey:       "575d966b783206f575cf0569b79891a12a356ccaf321a4dc5bb9eac733ca71da"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5af24f1682c20a88340c1fd4750fad764da1af702d0e02e60c55a24593704c9"
    sha256 cellar: :any_skip_relocation, catalina:       "fa198bb727404ffcf910e8062b4b0422708ee1bff47952d8e6769b896d56c2b2"
    sha256 cellar: :any_skip_relocation, mojave:         "602b778078a7d661b40a0a0106bb8e8966d3aa6eeb4e111e534ef11c59df257f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ea9d6b366666d7f2f80cbd81f9afa793b51a3044426a4d06c0219075fc47b30"
  end

  depends_on "python@3.10"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/48/1a/ba9542a545aed4b0b6ef128561f68dd3c2812ff5abfa9ed5b96547a728ea/aiohttp-3.8.0.tar.gz"
    sha256 "d3b19d8d183bcfd68b25beebab8dc3308282fe2ca3d6ea3cb4cd101b3c279f8d"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/27/6b/a89fbcfae70cf53f066ec22591938296889d3cc58fec1e1c393b10e8d71d/aiosignal-1.2.0.tar.gz"
    sha256 "78ed67db6c7b7ced4f98e495e572106d5c432a93e1ddd1bf475e1dc05f5b7df2"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/28/92/2690d8d667971e456226cd7f6fe748c1ac290e68b078bace8764705fde1e/async-timeout-4.0.0a3.tar.gz"
    sha256 "e6edc264ebcc8d3d06d16d687aff0ebf686f3cecf9a2d5f127629ea2044111b9"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/5c/ee/7c6287928ba776567603248e160387cf4143641ecf734e393ad9b2c82475/frozenlist-1.2.0.tar.gz"
    sha256 "68201be60ac56aff972dc18085800b6ee07973c49103a8aba669dee3d71079de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/8e/7c/e12a69795b7b7d5071614af2c691c97fbf16a2a513c66ec52dd7d0a115bb/multidict-5.2.0.tar.gz"
    sha256 "0dd1c93edb444b33ba2274b66f63def8a327d607c6c790772f448a53b6ea59ce"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/4b/96/d70b9462671fbeaacba4639ff866fb4e9e558580853fc5d6e698d0371ad4/platformdirs-2.4.0.tar.gz"
    sha256 "367a5e80b3d04d2428ffa76d33f124cf11e8fff2acdaa9b43d545f5c7d661ef2"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/33/a0/2ee4938d1e21eb280a79136e290d9e4a80e66115a093f8b7f1be74ac99e2/regex-2021.10.23.tar.gz"
    sha256 "f3f9a91d3cc5e5b0ddf1043c0ae5fa4852f18a1c0050318baf5fc7930ecc1f9c"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/aa/5b/62165da80cbc6e1779f342234c7ddc6c6bc9e64cef149046a9c0456f912b/tomli-1.2.2.tar.gz"
    sha256 "c6ce0015eb38820eaf32b5db832dbc26deb3dd427bd5f6556cf0acac2c214fee"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/ed/12/c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98/typing_extensions-3.10.0.2.tar.gz"
    sha256 "49f75d16ff11f1cd258e1b988ccff82a3ca5570217d7ad8c5f48205dd99a677e"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/7f/5c/a4ce6d4f46413afe49734bf901939105f4ce7fcfbcf87d0777cc39501060/yarl-1.7.0.tar.gz"
    sha256 "8e7ebaf62e19c2feb097ffb7c94deb0f0c9fab52590784c8cd679d30ab009162"
  end

  def install
    virtualenv_install_with_resources
  end

  plist_options startup: true

  service do
    run opt_bin/"blackd"
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/blackd.log"
    error_log_path var/"log/blackd.log"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"black_test.py").write <<~EOS
      print(
      'It works!')
    EOS
    system bin/"black", "black_test.py"
    assert_equal "print(\"It works!\")\n", (testpath/"black_test.py").read
    port = free_port
    fork { exec "#{bin}/blackd --bind-host 127.0.0.1 --bind-port #{port}" }
    sleep 10
    assert_match "print(\"valid\")", shell_output("curl -s -XPOST localhost:#{port} -d \"print('valid')\"").strip
  end
end
