class Black < Formula
  include Language::Python::Virtualenv

  desc "Python code formatter"
  homepage "https://black.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/b3/d6/d1aa2fdb633d092cf43ec4c96b0035a0a3a4f579b691205f96ccbd4e0032/black-21.5b2.tar.gz"
  sha256 "1fc0e0a2c8ae7d269dfcf0c60a89afa299664f3e811395d40b1922dff8f854b5"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/black[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3e24da14845c2704fa37262906e62a9121ead3ef26d9534e14fce67526ddeb86"
    sha256 cellar: :any_skip_relocation, big_sur:       "e562a03862e88ef6764ab690f9540f26f59511a4ae259e65bde6b73e87b7fbb0"
    sha256 cellar: :any_skip_relocation, catalina:      "fd335c3d8e9e8fe9b10bcd5c8e01ca385c91de8ef7486de1af9420a8969f1e5a"
    sha256 cellar: :any_skip_relocation, mojave:        "d156e1da447145bcce69d80bd7e6cc0379e0d6bdfe14000c2fff3bce404d6ac5"
  end

  depends_on "python@3.9"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/99/f5/90ede947a3ce2d6de1614799f5fea4e93c19b6520a59dc5d2f64123b032f/aiohttp-3.7.4.post0.tar.gz"
    sha256 "493d3299ebe5f5a7c66b9819eacdcfbbaaf1a8e84911ddffcdc48888497afecf"
  end

  resource "aiohttp_cors" do
    url "https://files.pythonhosted.org/packages/44/9e/6cdce7c3f346d8fd487adf68761728ad8cd5fbc296a7b07b92518350d31f/aiohttp-cors-0.7.0.tar.gz"
    sha256 "4d39c6d7100fd9764ed1caf8cebf0eb01bf5e3f24e2e073fda6234bc48b19f5d"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/a1/78/aae1545aba6e87e23ecab8d212b58bb70e72164b67eb090b81bb17ad38e3/async-timeout-3.0.1.tar.gz"
    sha256 "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1c/74/e8b46156f37ca56d10d895d4e8595aa2b344cff3c1fb3629ec97a8656ccb/multidict-5.1.0.tar.gz"
    sha256 "25b4e5f22d3a37ddf3effc0710ba692cfc792c2b9edfb9c05aefe823256e84d5"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/b7/64/e097eea8dcd2b2f7df6e4425fc98e7494e37b1a6e149603c31d327080a05/pathspec-0.8.1.tar.gz"
    sha256 "86379d6b86d75816baba717e64b1a3a3469deb93bb76d613c9ce79edc5cb68fd"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/38/3f/4c42a98c9ad7d08c16e7d23b2194a0e4f3b2914662da8bc88986e4e6de1f/regex-2021.4.4.tar.gz"
    sha256 "52ba3d3f9b942c49d7e4bc105bb28551c44065f139a65062ab7912bef10c9afb"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/aa/55/62e2d4934c282a60b4243a950c9dbfa01ae7cac0e8d6c0b5315b87432c81/typing_extensions-3.10.0.0.tar.gz"
    sha256 "50b6f157849174217d0656f99dc82fe932884fb250826c18350e159ec6cdf342"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/97/e7/af7219a0fe240e8ef6bb555341a63c43045c21ab0392b4435e754b716fa1/yarl-1.6.3.tar.gz"
    sha256 "8a9066529240171b68893d60dca86a763eae2139dd42f42106b03cf4b426bf10"
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
    fork { exec "#{bin}/blackd --bind-port #{port}" }
    sleep 10
    assert_match "print(\"valid\")", shell_output("curl -s -XPOST localhost:#{port} -d \"print('valid')\"").strip
  end
end
