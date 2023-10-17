class Gdbgui < Formula
  include Language::Python::Virtualenv

  desc "Modern, browser-based frontend to gdb (gnu debugger)"
  homepage "https://www.gdbgui.com/"
  url "https://files.pythonhosted.org/packages/d2/95/1a5d6fff8e4c8458b314dd5175944579a0f6233f963c657bc5d3c6b2f3b2/gdbgui-0.15.1.0.tar.gz"
  sha256 "61c0f7a26ecdeb275d9b4d88b7afdf8d70ec5471b40ace3a7dd1a87f43cc2573"
  license "GPL-3.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma:       "90f57ed26219bc56ba9d4cd6723e1be22671ab33b61e4dd82607cf5fb13c07ff"
    sha256 cellar: :any_skip_relocation, ventura:      "93601eb1af66befa802f36eb45afc053f172cb6c19e5a6281c1b3f0f75d544f9"
    sha256 cellar: :any_skip_relocation, monterey:     "6cac4a7fd50072c2108068772edf1ba7e78270946c428620b47ca81139e644e2"
    sha256 cellar: :any_skip_relocation, big_sur:      "d1a4536b5eb571a9ca4fcffc86a0529712ac50340131a1681c32a38af7e1a218"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "36eb1049e48848080019c1533e14b63a43041667389e5ba0f8353adab5b3db17"
  end

  # No activity since June, 2022 (https://github.com/cs01/gdbgui).
  # Dependencies declared in the repo are no longer compatible with recent
  # Python versions.
  deprecate! date: "2023-05-25", because: :unmaintained

  depends_on arch: :x86_64 # gdb is not supported on macOS ARM
  depends_on "gdb"
  depends_on "python@3.12"
  depends_on "six"

  resource "bidict" do
    url "https://files.pythonhosted.org/packages/bd/7c/83fbbc8568be511bc48704b97ef58f67ff2ab85ec4fcd1dad12cd2323c32/bidict-0.21.2.tar.gz"
    sha256 "4fa46f7ff96dc244abfc437383d987404ae861df797e2fd5b190e233c302be09"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/99/fb/e7cd35bba24295ad41abfdff30f6b4c271fd6ac70d20132fa503c3e768e0/dnspython-2.2.1.tar.gz"
    sha256 "0f7569a4a6ff151958b64304071d370daa3243d15941a7beedf0c9fe5105603e"
  end

  resource "eventlet" do
    url "https://files.pythonhosted.org/packages/12/c9/898ab514f82fb8f9a5a37a36c44a798c023fc42d6de863ad940861222ad4/eventlet-0.33.0.tar.gz"
    sha256 "80144f489c1bb273a51b6f96ff9785a382d2866b9bab1f5bd748385019f4141f"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/c0/df/c516b5f38a670b6b0de604c2637ed5860db03692c2f8542fd1f60c2552a7/Flask-2.0.1.tar.gz"
    sha256 "1c4c257b1892aec1398784c63791cbaa43062f1f7aeb555c4da961b20ee68f55"
  end

  resource "flask-compress" do
    url "https://files.pythonhosted.org/packages/ba/8f/85eac7b4ac5c05fd6cb9e2c9fbc592be33265053095b860c809967532c18/Flask-Compress-1.10.1.tar.gz"
    sha256 "28352387efbbe772cfb307570019f81957a13ff718d994a9125fa705efb73680"
  end

  resource "flask-socketio" do
    url "https://files.pythonhosted.org/packages/5f/a5/5c03d62fdbdf0343345c8cca19d4961d8958eba54449230df2b0080b7011/Flask-SocketIO-5.1.1.tar.gz"
    sha256 "1efdaacc7a26e94f2b197a80079b1058f6aa644a6094c0a322349e2b9c41f6b1"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/0c/10/754e21b5bea89d0e73f99d60c83754df7cc64db74f47d98ab187669ce341/greenlet-1.1.2.tar.gz"
    sha256 "e30f5ea4ae2346e62cedde8794a56858a67b878dd79f7df76a0767e356b1744a"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/58/66/d6c5859dcac92b442626427a8c7a42322068c5cd5d4a463ce78b93f730b7/itsdangerous-2.0.1.tar.gz"
    sha256 "9e724d68fc22902a1435351f84c3fb8623f303fffcc566a4cb952df8c572cff0"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/39/11/8076571afd97303dfeb6e466f27187ca4970918d4b36d5326725514d3ed3/Jinja2-3.0.1.tar.gz"
    sha256 "703f484b47a6af502e743c9122595cc812b0271f661722403114f71a79d0f5a4"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "pygdbmi" do
    url "https://files.pythonhosted.org/packages/a8/0a/54f3f197a4a097d36b0025b600dba12a269b92c380a45c9f6bbb4635e0d0/pygdbmi-0.10.0.1.tar.gz"
    sha256 "308a8cc7a002e90e3588f5a480127d7f5d95ebd0ba9993aeeee985aa418e78be"
  end

  resource "pygments" do
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

  resource "werkzeug" do
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
      exec bin/"gdbgui", "-n", "-p", port.to_s
    end
    sleep 3

    assert_match "gdbgui - gdb in a browser", shell_output("curl -s 127.0.0.1:#{port}")
  end
end
