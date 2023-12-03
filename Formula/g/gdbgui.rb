class Gdbgui < Formula
  include Language::Python::Virtualenv

  desc "Modern, browser-based frontend to gdb (gnu debugger)"
  homepage "https://www.gdbgui.com/"
  url "https://files.pythonhosted.org/packages/f5/22/b26e8ee14c570768bfa85a7efe1a384c8b07fee7d966ee067bf9e8fa3033/gdbgui-0.15.2.0.tar.gz"
  sha256 "be63254668c5aa1b3755ff8853d203b49cede1d674c883a65c854ec7972164f0"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, sonoma:       "90f57ed26219bc56ba9d4cd6723e1be22671ab33b61e4dd82607cf5fb13c07ff"
    sha256 cellar: :any_skip_relocation, ventura:      "93601eb1af66befa802f36eb45afc053f172cb6c19e5a6281c1b3f0f75d544f9"
    sha256 cellar: :any_skip_relocation, monterey:     "6cac4a7fd50072c2108068772edf1ba7e78270946c428620b47ca81139e644e2"
    sha256 cellar: :any_skip_relocation, big_sur:      "d1a4536b5eb571a9ca4fcffc86a0529712ac50340131a1681c32a38af7e1a218"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "36eb1049e48848080019c1533e14b63a43041667389e5ba0f8353adab5b3db17"
  end

  depends_on arch: :x86_64 # gdb is not supported on macOS ARM
  depends_on "gdb"
  depends_on "pygments"
  depends_on "python-brotli"
  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python@3.12"
  depends_on "six"

  resource "bidict" do
    url "https://files.pythonhosted.org/packages/f2/be/b31e6ea9c94096a323e7a0e2c61480db01f07610bb7e7ea72a06fd1a23a8/bidict-0.22.1.tar.gz"
    sha256 "1e0f7f74e4860e6d0943a05d4134c63a2fad86f3d4732fb265bd79e4e856d81d"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/ea/96/ed1420a974540da7419094f2553bc198c454cee5f72576e7c7629dd12d6e/blinker-1.6.3.tar.gz"
    sha256 "152090d27c1c5c722ee7e48504b02d76502811ce02e1523553b4cf8c8b3d3a8d"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "eventlet" do
    url "https://files.pythonhosted.org/packages/81/0c/5e0bcf715a2bae9169c77bfdcbc460a4aeeb0bb1067cf8071cf14d7d1b39/eventlet-0.33.3.tar.gz"
    sha256 "722803e7eadff295347539da363d68ae155b8b26ae6a634474d0a920be73cfda"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/d8/09/c1a7354d3925a3c6c8cfdebf4245bae67d633ffda1ba415add06ffc839c5/flask-3.0.0.tar.gz"
    sha256 "cfadcdb638b609361d29ec22360d6070a77d7463dcb3ab08d2c2f2f168845f58"
  end

  resource "flask-compress" do
    url "https://files.pythonhosted.org/packages/ba/8f/85eac7b4ac5c05fd6cb9e2c9fbc592be33265053095b860c809967532c18/Flask-Compress-1.10.1.tar.gz"
    sha256 "28352387efbbe772cfb307570019f81957a13ff718d994a9125fa705efb73680"
  end

  resource "flask-socketio" do
    url "https://files.pythonhosted.org/packages/33/b2/aa882384d130523d7d2d6eed33403aed68a438622df388d92171d7657960/Flask-SocketIO-5.3.6.tar.gz"
    sha256 "bb8f9f9123ef47632f5ce57a33514b0c0023ec3696b2384457f0fcaa5b70501c"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/b6/02/47dbd5e1c9782e6d3f58187fa10789e308403f3fc3a490b3646b2bff6d9f/greenlet-3.0.0.tar.gz"
    sha256 "19834e3f91f485442adc1ee440171ec5d9a4840a1f7bd5ed97833544719ce10b"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "pygdbmi" do
    url "https://files.pythonhosted.org/packages/f5/74/67e1d69287950e527798db40a4478a4a5cd7da08130de29a74c3433a016d/pygdbmi-0.10.0.2.tar.gz"
    sha256 "81dfc9e7ffd49f5006685a243905cee72216303e5ea42f6588793dfb8c8407ab"
  end

  resource "python-engineio" do
    url "https://files.pythonhosted.org/packages/c4/5c/4fa0bf79eb1a433d1e9b69430b3ac818837283c642640658f12949620813/python-engineio-4.8.0.tar.gz"
    sha256 "2a32585d8fecd0118264fe0c39788670456ca9aa466d7c026d995cfff68af164"
  end

  resource "python-socketio" do
    url "https://files.pythonhosted.org/packages/02/2c/24999038d26680110d6dac5305f4d1550c0ef2c9945adbff89ca16720d0c/python-socketio-5.10.0.tar.gz"
    sha256 "01c616946fa9f67ed5cc3d1568e1c4940acfc64aeeb9ff621a53e80cabeb748a"
  end

  resource "simple-websocket" do
    url "https://files.pythonhosted.org/packages/d3/82/3cf87d317911864a2f2a8daf1779fc7f82d5d55e6a8aaa0315f8209047a7/simple-websocket-1.0.0.tar.gz"
    sha256 "17d2c72f4a2bd85174a97e3e4c88b01c40c3f81b7b648b0cc3ce1305968928c8"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/8c/47/75c7099c78dc207486e30cdb2b16059ca6d5c6cdcf9290f4621368bd06e4/werkzeug-3.0.0.tar.gz"
    sha256 "3ffff4dcc32db52ef3cc94dff3000a3c2846890f3a5a51800a27b909c5e770f0"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c9/4a/44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5a/wsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
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
