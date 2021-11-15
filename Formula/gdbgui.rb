class Gdbgui < Formula
  include Language::Python::Virtualenv

  desc "Modern, browser-based frontend to gdb (gnu debugger)"
  homepage "https://www.gdbgui.com/"
  url "https://files.pythonhosted.org/packages/4b/67/63e55e2fde8628603326e5a9f1882bf831f49b2feaa966aee602fced77ae/gdbgui-0.15.0.1.tar.gz"
  sha256 "6f0ae578b9f7181c783227b692e8ed694a3e5c200b33e8512f2488644465060d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "66ab0fe289baa0e06dca98ce2c3fbb6179093da983faab5119967ca33554e372"
    sha256 cellar: :any_skip_relocation, big_sur:      "62870c658d7305914e55b06977f1bdd3599cdb5678b0a9b92cb8998f561bddea"
    sha256 cellar: :any_skip_relocation, catalina:     "2f3943c95fd3a2345b6e0da211d4aaaa701dd295ff73c5b0e6ca576e357acc34"
    sha256 cellar: :any_skip_relocation, mojave:       "419065456561b0783e97f2a556d937b9d171b2869db0a34a5c2216363aee2b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e09f4154e95193c7972f0f55508792397338383125248ef3394cfe17a4a016cc"
  end

  depends_on "gdb"
  depends_on "python@3.9"

  resource "bidict" do
    url "https://files.pythonhosted.org/packages/bd/7c/83fbbc8568be511bc48704b97ef58f67ff2ab85ec4fcd1dad12cd2323c32/bidict-0.21.2.tar.gz"
    sha256 "4fa46f7ff96dc244abfc437383d987404ae861df797e2fd5b190e233c302be09"
  end

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/c0/df/c516b5f38a670b6b0de604c2637ed5860db03692c2f8542fd1f60c2552a7/Flask-2.0.1.tar.gz"
    sha256 "1c4c257b1892aec1398784c63791cbaa43062f1f7aeb555c4da961b20ee68f55"
  end

  resource "Flask-Compress" do
    url "https://files.pythonhosted.org/packages/ba/8f/85eac7b4ac5c05fd6cb9e2c9fbc592be33265053095b860c809967532c18/Flask-Compress-1.10.1.tar.gz"
    sha256 "28352387efbbe772cfb307570019f81957a13ff718d994a9125fa705efb73680"
  end

  resource "Flask-SocketIO" do
    url "https://files.pythonhosted.org/packages/5f/a5/5c03d62fdbdf0343345c8cca19d4961d8958eba54449230df2b0080b7011/Flask-SocketIO-5.1.1.tar.gz"
    sha256 "1efdaacc7a26e94f2b197a80079b1058f6aa644a6094c0a322349e2b9c41f6b1"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/58/66/d6c5859dcac92b442626427a8c7a42322068c5cd5d4a463ce78b93f730b7/itsdangerous-2.0.1.tar.gz"
    sha256 "9e724d68fc22902a1435351f84c3fb8623f303fffcc566a4cb952df8c572cff0"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/39/11/8076571afd97303dfeb6e466f27187ca4970918d4b36d5326725514d3ed3/Jinja2-3.0.1.tar.gz"
    sha256 "703f484b47a6af502e743c9122595cc812b0271f661722403114f71a79d0f5a4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "pygdbmi" do
    url "https://files.pythonhosted.org/packages/a8/0a/54f3f197a4a097d36b0025b600dba12a269b92c380a45c9f6bbb4635e0d0/pygdbmi-0.10.0.1.tar.gz"
    sha256 "308a8cc7a002e90e3588f5a480127d7f5d95ebd0ba9993aeeee985aa418e78be"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "python-engineio" do
    url "https://files.pythonhosted.org/packages/74/1e/33e402011bb2fe33ab12762e5a66d66df1d47302a23e9c5e8310e11b1403/python-engineio-4.2.1.tar.gz"
    sha256 "d510329b6d8ed5662547862f58bc73659ae62defa66b66d745ba021de112fa62"
  end

  resource "python-socketio" do
    url "https://files.pythonhosted.org/packages/72/70/9b992f4b8adfcbf0724c079c18629d83f20b36fb0eb64d4fdf874054becf/python-socketio-5.4.0.tar.gz"
    sha256 "ca807c9e1f168e96dea412d64dd834fb47c470d27fd83da0504aa4b248ba2544"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/e3/bd/a49e5f756b2f29010b5be321fe02478660dbf8fefea3f078493c86011b5f/Werkzeug-2.0.1.tar.gz"
    sha256 "1de1db30d010ff1af14a009224ec49ab2329ad2cde454c8a708130642d579c42"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/gdbgui -v").strip
    port = free_port

    fork do
      # Work around a gevent/greenlet bug
      # https://github.com/cs01/gdbgui/issues/359
      ENV["PURE_PYTHON"] = "1"
      exec bin/"gdbgui", "-n", "-p", port.to_s
    end
    sleep 3

    assert_match "gdbgui - gdb in a browser", shell_output("curl -s 127.0.0.1:#{port}")
  end
end
