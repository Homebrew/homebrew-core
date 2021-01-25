class Gdbgui < Formula
  include Language::Python::Virtualenv

  desc "Modern, browser-based frontend to gdb (gnu debugger)"
  homepage "https://www.gdbgui.com/"
  url "https://files.pythonhosted.org/packages/1c/e8/98be1d2150d6625dbc53b4f7daf76850bee90c503794897156727483aa66/gdbgui-0.14.0.2.tar.gz"
  sha256 "4d80a9baa66ef90f1a99b7b859be75743928ca65bfea77587914dac7ace6dcec"
  license "GPL-3.0-only"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "01ab2720fb16cd45b07f7f64cacc395122ed74002914a7e49501a86676ccd12f" => :big_sur
    sha256 "083fcf08771cf6fffe1a2dd0a11ab0aaa2b430dee8f89a38bc67abbc4ee92b40" => :catalina
    sha256 "2e142057b5aac7280b532045372a1c3f86d9af8e18aa3f9461be23ac6a2afef9" => :mojave
  end

  depends_on "gdb"
  depends_on "python@3.9"

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/67/d0/639a9b5273103a18c5c68a7a9fc02b01cffa3403e72d553acec444f85d5b/dnspython-2.0.0.zip"
    sha256 "044af09374469c3a39eeea1a146e8cac27daec951f1f1f157b1962fc7cb9d1b7"
  end

  resource "eventlet" do
    url "https://files.pythonhosted.org/packages/2a/df/943d5aa7029b47dd3eb41e1ea48f843d3441d24b7e0b76a0b3af4df35a83/eventlet-0.25.2.tar.gz"
    sha256 "4c8ab42c51bff55204fef43cff32616558bedbc7538d876bb6a96ce820c7f9ed"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/32/57/3c33fe153ea008e9e0202eb028972178337c55777686aac03f41ade671f8/Flask-0.12.5.tar.gz"
    sha256 "fac2b9d443e49f7e7358a444a3db5950bdd0324674d92ba67f8f1f15f876b14f"
  end

  resource "Flask-Compress" do
    url "https://files.pythonhosted.org/packages/eb/33/7bcfc1d240bf4cf701cc742716a3af95b9df5b26d605559ea029b6ffa04f/Flask-Compress-1.8.0.tar.gz"
    sha256 "c132590e7c948877a96d675c13cbfa64edec0faafa2381678dea6f36aa49a552"
  end

  resource "Flask-SocketIO" do
    url "https://files.pythonhosted.org/packages/5d/94/6f55de2fd72f1d7f7eb17cd6045a50581e7c66d53580fc93fd607a5cd630/Flask-SocketIO-2.9.6.tar.gz"
    sha256 "f49edfd3a44458fbb9f7a04a57069ffc0c37f000495194f943a25d370436bb69"
  end

  resource "gevent" do
    url "https://files.pythonhosted.org/packages/5a/79/2c63d385d017b5dd7d70983a463dfd25befae70c824fedb857df6e72eff2/gevent-1.5.0.tar.gz"
    sha256 "b2814258e3b3fb32786bb73af271ad31f51e1ac01f33b37426b66cb8491b4c29"
  end

  resource "gevent-websocket" do
    url "https://files.pythonhosted.org/packages/98/d2/6fa19239ff1ab072af40ebf339acd91fb97f34617c2ee625b8e34bf42393/gevent-websocket-0.10.1.tar.gz"
    sha256 "7eaef32968290c9121f7c35b973e2cc302ffb076d018c9068d2f5ca8b2d85fb0"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/20/5e/b989a19f4597b825f44125345cd8a8574216fae7fafe69e2cb1238ebd18a/greenlet-0.4.16.tar.gz"
    sha256 "6e06eac722676797e8fce4adb8ad3dc57a1bb3adfb0dd3fdf8306c055a38456c"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/68/1a/f27de07a8a304ad5fa817bbe383d1238ac4396da447fa11ed937039fa04b/itsdangerous-1.1.0.tar.gz"
    sha256 "321b033d07f2a4136d3ec762eac9f16a10ccd60f53c0c91af90217ace7ba1f19"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz"
    sha256 "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/19/c1/27f722aaaaf98786a1b338b78cf60960d9fe4849825b071f4e300da29589/monotonic-1.5.tar.gz"
    sha256 "23953d55076df038541e648a53676fb24980f7a1be290cdda21300b3bc21dfb0"
  end

  resource "pygdbmi" do
    url "https://files.pythonhosted.org/packages/30/01/9523d5ed7bccf7f94927b3dc7a616c9b4a8dfe57df89e67571d32d87717a/pygdbmi-0.10.0.0.tar.gz"
    sha256 "0706b81404a77f78f8b51db43205e94a7ac8fd7ce87b6eac2681baadeff85826"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/29/60/8ff9dcb5eac7f4da327ba9ecb74e1ad783b2d32423c06ef599e48c79b1e1/Pygments-2.7.3.tar.gz"
    sha256 "ccf3acacf3782cbed4a989426012f1c535c9a90d3a7fc3f16d231b9372d2b716"
  end

  resource "python-engineio" do
    url "https://files.pythonhosted.org/packages/7d/a3/9491c16fae684011c51cc94513e17153bacfb5509c71c68dde6c5abd51fc/python-engineio-3.14.2.tar.gz"
    sha256 "eab4553f2804c1ce97054c8b22cf0d5a9ab23128075248b97e1a5b2f29553085"
  end

  resource "python-socketio" do
    url "https://files.pythonhosted.org/packages/6e/6c/b899d7a34503d5e4b6967ee3fec996acee75d0cd087c22963134c88f8ca1/python-socketio-4.6.1.tar.gz"
    sha256 "cd1f5aa492c1eb2be77838e837a495f117e17f686029ebc03d62c09e33f4fa10"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/c3/1d/1c0761d9365d166dc9d882a48c437111d22b0df564d6d5768045d9a51fd0/Werkzeug-0.16.1.tar.gz"
    sha256 "b353856d37dec59d6511359f97f6a4b2468442e454bd1c98298ddce53cac1f04"
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
