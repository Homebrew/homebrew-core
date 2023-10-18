class Gdbgui < Formula
  include Language::Python::Virtualenv

  desc "Modern, browser-based frontend to gdb (gnu debugger)"
  homepage "https://www.gdbgui.com/"
  url "https://files.pythonhosted.org/packages/d2/95/1a5d6fff8e4c8458b314dd5175944579a0f6233f963c657bc5d3c6b2f3b2/gdbgui-0.15.1.0.tar.gz"
  sha256 "61c0f7a26ecdeb275d9b4d88b7afdf8d70ec5471b40ace3a7dd1a87f43cc2573"
  license "GPL-3.0-only"

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
  depends_on "python@3.11"
  depends_on "six"

  resource "bidict" do
    url "https://files.pythonhosted.org/packages/f2/be/b31e6ea9c94096a323e7a0e2c61480db01f07610bb7e7ea72a06fd1a23a8/bidict-0.22.1.tar.gz"
    sha256 "1e0f7f74e4860e6d0943a05d4134c63a2fad86f3d4732fb265bd79e4e856d81d"
  end

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/91/8b/522301c50ca1f78b09c2ca116ffb0fd797eadf6a76085d376c01f9dd3429/dnspython-2.3.0.tar.gz"
    sha256 "224e32b03eb46be70e12ef6d64e0be123a64e621ab4c0822ff6d450d52a540b9"
  end

  resource "eventlet" do
    url "https://files.pythonhosted.org/packages/81/0c/5e0bcf715a2bae9169c77bfdcbc460a4aeeb0bb1067cf8071cf14d7d1b39/eventlet-0.33.3.tar.gz"
    sha256 "722803e7eadff295347539da363d68ae155b8b26ae6a634474d0a920be73cfda"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/69/b6/53cfa30eed5aa7343daff36622843688ba8c6fe9829bb2b92e193ab1163f/Flask-2.2.2.tar.gz"
    sha256 "642c450d19c4ad482f96729bd2a8f6d32554aa1e231f4f6b4e7e5264b16cca2b"
  end

  resource "Flask-Compress" do
    url "https://files.pythonhosted.org/packages/ba/8f/85eac7b4ac5c05fd6cb9e2c9fbc592be33265053095b860c809967532c18/Flask-Compress-1.10.1.tar.gz"
    sha256 "28352387efbbe772cfb307570019f81957a13ff718d994a9125fa705efb73680"
  end

  resource "Flask-SocketIO" do
    url "https://files.pythonhosted.org/packages/5f/a5/5c03d62fdbdf0343345c8cca19d4961d8958eba54449230df2b0080b7011/Flask-SocketIO-5.1.1.tar.gz"
    sha256 "1efdaacc7a26e94f2b197a80079b1058f6aa644a6094c0a322349e2b9c41f6b1"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/1e/1e/632e55a04d732c8184201238d911207682b119c35cecbb9a573a6c566731/greenlet-2.0.2.tar.gz"
    sha256 "e7c8dc13af7db097bed64a051d2dd49e9f0af495c26995c00a9ee842690d34c0"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "pygdbmi" do
    url "https://files.pythonhosted.org/packages/f5/74/67e1d69287950e527798db40a4478a4a5cd7da08130de29a74c3433a016d/pygdbmi-0.10.0.2.tar.gz"
    sha256 "81dfc9e7ffd49f5006685a243905cee72216303e5ea42f6588793dfb8c8407ab"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/da/6a/c427c06913204e24de28de5300d3f0e809933f376e0b7df95194b2bb3f71/Pygments-2.14.0.tar.gz"
    sha256 "b3ed06a9e8ac9a9aae5a6f5dbe78a8a58655d17b43b93c078f094ddc476ae297"
  end

  resource "python-engineio" do
    url "https://files.pythonhosted.org/packages/7e/ff/970c5d084f513fb38108cd7c90497489d7cff8666f9bfabae00a3f4e13d4/python-engineio-4.3.4.tar.gz"
    sha256 "d8d8b072799c36cadcdcc2b40d2a560ce09797ab3d2d596b2ad519a5e4df19ae"
  end

  resource "python-socketio" do
    url "https://files.pythonhosted.org/packages/ee/56/294629986bf6cea96e0edb3933a7f2fac7a079d12909e893903a2effc670/python-socketio-5.7.2.tar.gz"
    sha256 "92395062d9db3c13d30e7cdedaa0e1330bba78505645db695415f9a3c628d097"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/f8/c1/1c8e539f040acd80f844c69a5ef8e2fccdf8b442dabb969e497b55d544e1/Werkzeug-2.2.2.tar.gz"
    sha256 "7ea2d48322cc7c0f8b3a215ed73eabd7b5d75d0b50e31ab006286ccff9e00b8f"
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
