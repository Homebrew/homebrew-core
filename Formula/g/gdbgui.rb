class Gdbgui < Formula
  include Language::Python::Virtualenv

  desc "Modern, browser-based frontend to gdb (gnu debugger)"
  homepage "https://www.gdbgui.com/"
  url "https://files.pythonhosted.org/packages/f5/22/b26e8ee14c570768bfa85a7efe1a384c8b07fee7d966ee067bf9e8fa3033/gdbgui-0.15.2.0.tar.gz"
  sha256 "be63254668c5aa1b3755ff8853d203b49cede1d674c883a65c854ec7972164f0"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "98297f04a9bfa7028485e946f78e8fd3b3626f86976457c6d2115cd343a67288"
    sha256 cellar: :any_skip_relocation, ventura:      "9050299328bdf5d618bf88f6035dbf87ba9a78eeb30e7d6aaac7f89fd22d4593"
    sha256 cellar: :any_skip_relocation, monterey:     "522f9c070c12a7fb7d3b3d1355dc4b425dc1f8f6a4a22ad898f11eb2cc62b3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3e21d4de715f9491188306dd090bbc23f6fabe60eadf6b1e65238d19e30abee5"
  end

  depends_on "gdb"
  depends_on "python@3.12"

  on_macos do
    depends_on arch: :x86_64 # gdb is not supported on macOS ARM
  end

  resource "bidict" do
    url "https://files.pythonhosted.org/packages/f2/be/b31e6ea9c94096a323e7a0e2c61480db01f07610bb7e7ea72a06fd1a23a8/bidict-0.22.1.tar.gz"
    sha256 "1e0f7f74e4860e6d0943a05d4134c63a2fad86f3d4732fb265bd79e4e856d81d"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/ea/96/ed1420a974540da7419094f2553bc198c454cee5f72576e7c7629dd12d6e/blinker-1.6.3.tar.gz"
    sha256 "152090d27c1c5c722ee7e48504b02d76502811ce02e1523553b4cf8c8b3d3a8d"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "eventlet" do
    url "https://files.pythonhosted.org/packages/5e/a1/079895f493a7c7eef5d1fb1335aba96e05527fd22dc6cead98ff38acdd3a/eventlet-0.35.2.tar.gz"
    sha256 "8d1263e20b7f816a046ac60e1d272f9e5bc503f7a34d9adc789f8a85b14fa57d"
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

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "pygdbmi" do
    url "https://files.pythonhosted.org/packages/f5/74/67e1d69287950e527798db40a4478a4a5cd7da08130de29a74c3433a016d/pygdbmi-0.10.0.2.tar.gz"
    sha256 "81dfc9e7ffd49f5006685a243905cee72216303e5ea42f6588793dfb8c8407ab"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/d6/f7/4d461ddf9c2bcd6a4d7b2b139267ca32a69439387cc1f02a924ff8883825/Pygments-2.16.1.tar.gz"
    sha256 "1daff0494820c69bc8941e407aa20f577374ee88364ee10a98fdbe0aece96e29"
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

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
