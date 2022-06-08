class Gdbgui < Formula
  include Language::Python::Virtualenv

  desc "Modern, browser-based frontend to gdb (gnu debugger)"
  homepage "https://www.gdbgui.com/"
  url "https://files.pythonhosted.org/packages/4b/67/63e55e2fde8628603326e5a9f1882bf831f49b2feaa966aee602fced77ae/gdbgui-0.15.0.1.tar.gz"
  sha256 "6f0ae578b9f7181c783227b692e8ed694a3e5c200b33e8512f2488644465060d"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "41aa20f182812d4b36a9a3787248b2e6f2eb6bd280f4dec5b51765efce060bd6"
    sha256 cellar: :any_skip_relocation, big_sur:      "0f053682295aea85e3b0b1c4ac395a06d681c42598c538c9b3ccd0ecbd8e4bd5"
    sha256 cellar: :any_skip_relocation, catalina:     "e9caccd71e072398ff7ebaffcff9f00ceff86c6fe6230360b582683ea23929ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a1970650715f513ee5e7c51574f1cb698889df5a509ba79f208782fd5b5d6167"
  end

  depends_on "gdb"
  depends_on "python@3.10"

  resource "bidict" do
    url "https://files.pythonhosted.org/packages/2b/84/159749556b9c49ea4489dadeb94d44f05d6033d1db3af4c83120ecac5b15/bidict-0.22.0.tar.gz"
    sha256 "5c826b3e15e97cc6e615de295756847c282a79b79c5430d3bfc909b1ac9f5bd8"
  end

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/d3/3c/94f38d4db919a9326a706ad56f05a7e6f0c8f7b7d93e2997cca54d3bc14b/Flask-2.1.2.tar.gz"
    sha256 "315ded2ddf8a6281567edb27393010fe3406188bafbfe65a3339d5787d89e477"
  end

  resource "Flask-Compress" do
    url "https://files.pythonhosted.org/packages/ba/8f/85eac7b4ac5c05fd6cb9e2c9fbc592be33265053095b860c809967532c18/Flask-Compress-1.10.1.tar.gz"
    sha256 "28352387efbbe772cfb307570019f81957a13ff718d994a9125fa705efb73680"
  end

  resource "Flask-SocketIO" do
    url "https://files.pythonhosted.org/packages/27/5c/4fea659fefebfec25dfda642ce9ee53fa208d3851261ff69178b47310b33/Flask-SocketIO-5.1.2.tar.gz"
    sha256 "933bcc887ef463a9b78d76f8f86174f63a32d12a5406b99f452cdf3b129ebba3"
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
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "pygdbmi" do
    url "https://files.pythonhosted.org/packages/f5/74/67e1d69287950e527798db40a4478a4a5cd7da08130de29a74c3433a016d/pygdbmi-0.10.0.2.tar.gz"
    sha256 "81dfc9e7ffd49f5006685a243905cee72216303e5ea42f6588793dfb8c8407ab"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "python-engineio" do
    url "https://files.pythonhosted.org/packages/dc/0f/44e7126a0f90c983e3fa4af0b976cd6bef313ad9786f099e30a54cc44660/python-engineio-4.3.2.tar.gz"
    sha256 "e02f8d6686663408533726be2d4ceb403914fd17285d247791c6a91623777bdd"
  end

  resource "python-socketio" do
    url "https://files.pythonhosted.org/packages/eb/a4/43e5f832831c09a0a9cf05d812d4904f74c5350df6c9ec98d80f78e43f4a/python-socketio-5.6.0.tar.gz"
    sha256 "f1f2eabdea500dbcb384902418cacedd98b7fe4d0fed818415ddf8af10e428fa"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/10/cf/97eb1a3847c01ae53e8376bc21145555ac95279523a935963dc8ff96c50b/Werkzeug-2.1.2.tar.gz"
    sha256 "1ce08e8093ed67d638d63879fd1ba3735817f7a80de3674d293f5984f25fb6e6"
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
