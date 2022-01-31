class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://black.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/42/58/8a3443a5034685152270f9012a9d196c9f165791ed3f2777307708b15f6c/black-22.1.0.tar.gz"
  sha256 "a7c0192d35635f6fc1174be575cb7915e92e5dd629ee79fdaf0dcfa41a80afb5"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/black[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "860cb8ca295ac8fae2773a2af867068975fe5dad382acbdfd371a8a67acde3af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e826f7a8998e9f305e6a40d16579a6704a5ae897e9df7aeaebb9aaa369c5bb8"
    sha256 cellar: :any_skip_relocation, monterey:       "2a5c74b04a85fb4c7ba649e518757d3b98b1d73255a2a445704303e6d7cc733f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f9929bdd2e862835a6cca7be5cdfd0f37640a248d4f7b6486d0d9969ff22ec6"
    sha256 cellar: :any_skip_relocation, catalina:       "3ac227a8450e6f20d1be1c2b1db962aa2a97f1074ed1bfdfd25320496e4c9e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad372eff82f62842df12832419790b792f08b10945f9eb8f156f637952033fec"
  end

  depends_on "python@3.10"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/5a/86/5f63de7a202550269a617a5d57859a2961f3396ecd1739a70b92224766bc/aiohttp-3.8.1.tar.gz"
    sha256 "fc5471e1a54de15ef71c1bc6ebe80d4dc681ea600e68bfd1cbce40427f0b7578"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/27/6b/a89fbcfae70cf53f066ec22591938296889d3cc58fec1e1c393b10e8d71d/aiosignal-1.2.0.tar.gz"
    sha256 "78ed67db6c7b7ced4f98e495e572106d5c432a93e1ddd1bf475e1dc05f5b7df2"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/48/44/76b179e0d1afe6e6a91fd5661c284f60238987f3b42b676d141d01cd5b97/charset-normalizer-2.0.10.tar.gz"
    sha256 "876d180e9d7432c5d1dfd4c5d26b72f099d503e8fcc0feb7532c9289be60fcbd"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/f4/f7/8dfeb76d2a52bcea2b0718427af954ffec98be1d34cd8f282034b3e36829/frozenlist-1.3.0.tar.gz"
    sha256 "ce6f2ba0edb7b0c1d8976565298ad2deba6f8064d2bebb6ffce2ca896eb35b0b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/fa/a7/71c253cdb8a1528802bac7503bf82fe674367e4055b09c28846fdfa4ab90/multidict-6.0.2.tar.gz"
    sha256 "5ff3bd75f38e4c43f1f470f2df7a4d430b821c4ce22be384e1459cb57d6bb013"
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
    url "https://files.pythonhosted.org/packages/be/00/bd080024010e1652de653bd61181e2dfdbef5fa73bfd32fec4c808991c31/platformdirs-2.4.1.tar.gz"
    sha256 "440633ddfebcc36264232365d7840a970e75e1018d15b4327d11f91909045fda"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/3d/6e/d290c9bf16159f02b70c432386aa5bfe22c2857ff460591912fd907b61f6/tomli-2.0.0.tar.gz"
    sha256 "c292c34f58502a1eb2bbb9f5bbc9a5ebc37bee10ffb8c2d6bbdfa8eb13cc14e1"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/f6/da/46d1b3d69a9a0835dabf9d59c7eb0f1600599edd421a4c5a15ab09f527e0/yarl-1.7.2.tar.gz"
    sha256 "45399b46d60c253327a460e99856752009fcee5f5d3c80b2f7c0cae1c38d56dd"
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
