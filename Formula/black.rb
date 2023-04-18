class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://black.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/d6/36/66370f5017b100225ec4950a60caeef60201a10080da57ddb24124453fba/black-23.3.0.tar.gz"
  sha256 "1c7b8d606e728a41ea1ccbd7264677e494e87cf630e399262ced92d4a8dac940"
  license "MIT"
  head "https://github.com/psf/black.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/black[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a54fec4396ec2bb81be07ceae652a57b34fa25f3893cf86654fbca290027c17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3cd90f75f5fe216b5ef3371bd76df33391ac9d1dc8a4adf3bdb0fe47d815a04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fc75edeeb6fe6a0c988043216b4335a2a6fa69167b68a745e6fddee9e0c2d97"
    sha256 cellar: :any_skip_relocation, ventura:        "9c272a9967d2bb544ee79364658b84ad743473f80aad42e279a5aa9d15c06e3a"
    sha256 cellar: :any_skip_relocation, monterey:       "1f29ab6926ae12580e4db61b50ba8c571cf850209e060cbc264c633d6c69eb8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4ea5fcd2a2b96c631d608acd7bf803816d30917249a24349737cf4b24fd1725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c445855ad98bfbdfeb0a1c9337a5030bcc375d4c807122a2062467c993e3a1b"
  end

  depends_on "python@3.11"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/c2/fd/1ff4da09ca29d8933fda3f3514980357e25419ce5e0f689041edb8f17dab/aiohttp-3.8.4.tar.gz"
    sha256 "bf2e1a9162c1e441bf805a1fd166e249d574ca04e03b34f97e2928769e91ab5c"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/e9/10/d629476346112b85c912527b9080944fd2c39a816c2225413dbc0bb6fcc0/frozenlist-1.3.3.tar.gz"
    sha256 "58bcc55721e8a90b88332d6cd441261ebb22342e238296bb330968952fbb3a6a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/95/60/d93628975242cc515ab2b8f5b2fc831d8be2eff32f5a1be4776d49305d13/pathspec-0.11.1.tar.gz"
    sha256 "2798de800fa92780e33acca925945e9a19a133b715067cf165b8866c15a31687"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/15/04/3f882b46b454ab374ea75425c6f931e499150ec1385a73e55b3f45af615a/platformdirs-3.2.0.tar.gz"
    sha256 "d5b638ca397f25f979350ff789db335903d7ea010ab28903f57b27e1b16c2b08"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/c4/1e/1b204050c601d5cd82b45d5c8f439cb6f744a2ce0c0a6f83be0ddf0dc7b2/yarl-1.8.2.tar.gz"
    sha256 "49d43402c6e3013ad0978602bf6bf5328535c48d192304b91b97a3c6790b1562"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run opt_bin/"blackd"
    keep_alive true
    require_root true
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
