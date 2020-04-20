class Gdbgui < Formula
  include Language::Python::Virtualenv

  desc "Modern, browser-based frontend to gdb (gnu debugger)"
  homepage "https://www.gdbgui.com/"
  url "https://github.com/cs01/gdbgui/archive/0.13.2.0.tar.gz"
  sha256 "325e4c6dd417d59b95ceb123173eee69d754f6ff3f97110c0cb960670460f858"

  depends_on "gdb"
  depends_on "python@3.8"

  resource "click" do
    url "https://files.pythonhosted.org/packages/4e/ab/5d6bc3b697154018ef196f5b17d958fac3854e2efbc39ea07a284d4a6a9b/click-7.1.1.tar.gz"
    sha256 "8a18b4ea89d8820c5d0c7da8a64b2c324b4dabb695804dbfea19b9be9d88c0cc"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/32/57/3c33fe153ea008e9e0202eb028972178337c55777686aac03f41ade671f8/Flask-0.12.5.tar.gz"
    sha256 "fac2b9d443e49f7e7358a444a3db5950bdd0324674d92ba67f8f1f15f876b14f"
  end

  resource "Flask-Compress" do
    url "https://files.pythonhosted.org/packages/0e/2a/378bd072928f6d92fd8c417d66b00c757dc361c0405a46a0134de6fd323d/Flask-Compress-1.4.0.tar.gz"
    sha256 "468693f4ddd11ac6a41bca4eb5f94b071b763256d54136f77957cfee635badb3"
  end

  resource "Flask-SocketIO" do
    url "https://files.pythonhosted.org/packages/5d/94/6f55de2fd72f1d7f7eb17cd6045a50581e7c66d53580fc93fd607a5cd630/Flask-SocketIO-2.9.6.tar.gz"
    sha256 "f49edfd3a44458fbb9f7a04a57069ffc0c37f000495194f943a25d370436bb69"
  end

  resource "gevent" do
    url "https://files.pythonhosted.org/packages/5a/79/2c63d385d017b5dd7d70983a463dfd25befae70c824fedb857df6e72eff2/gevent-1.5.0.tar.gz"
    sha256 "b2814258e3b3fb32786bb73af271ad31f51e1ac01f33b37426b66cb8491b4c29"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/f8/e8/b30ae23b45f69aa3f024b46064c0ac8e5fcb4f22ace0dca8d6f9c8bbe5e7/greenlet-0.4.15.tar.gz"
    sha256 "9416443e219356e3c31f1f918a91badf2e37acf297e2fa13d24d1cc2380f8fbc"
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

  resource "pygdbmi" do
    url "https://files.pythonhosted.org/packages/b1/06/f60cce2f9acb5ac4278cb1eedb7bb1a7bb52777b7ae74cd222c0068302fd/pygdbmi-0.9.0.3.tar.gz"
    sha256 "5bdf2f072e8f2f6471f19f8dcd87d6425c5d8069d47c0a5ffe8d0eff48cb171e"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
    sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"
  end

  resource "python-engineio" do
    url "https://files.pythonhosted.org/packages/71/5d/620b75396ce993001cbccc80dd786ab09a16a8e3f6c4878ad05f051064d6/python-engineio-3.12.1.tar.gz"
    sha256 "2481732d93646998f7372ef0ecf003af7817b82720b881db173c3d50b4887916"
  end

  resource "python-socketio" do
    url "https://files.pythonhosted.org/packages/9b/dd/45c2eb8fc9b8208cdf5948b468934b47f92ecca031c449863d8128d5cc15/python-socketio-4.5.1.tar.gz"
    sha256 "149b98c33f8c3d09273fb4ebeb83781e4dc9411b56b27d9f058bec1bd1ed74b7"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/c3/1d/1c0761d9365d166dc9d882a48c437111d22b0df564d6d5768045d9a51fd0/Werkzeug-0.16.1.tar.gz"
    sha256 "b353856d37dec59d6511359f97f6a4b2468442e454bd1c98298ddce53cac1f04"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    assert_equal "0.13.2.0", shell_output("#{bin}/gdbgui -v").strip

    fork do
      exec bin/"gdbgui", "-n"
    end
    sleep 3

    assert_match "gdbgui - gdb in a browser", shell_output("curl -s 127.0.0.1:5000")
  end
end
