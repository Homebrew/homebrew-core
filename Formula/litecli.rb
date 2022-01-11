class Litecli < Formula
  include Language::Python::Virtualenv

  desc "CLI for SQLite Databases with auto-completion and syntax highlighting"
  homepage "https://github.com/dbcli/litecli"
  url "https://files.pythonhosted.org/packages/a1/be/4a82f599f24990eb7f0a2b778bae0ab26113394819c7a06e9e036c72cd26/litecli-1.7.0.tar.gz"
  sha256 "6e6062aadb65203d3ef7b90ac51ca505c70d49637fac8ea093559410de725ba0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8830e874b2de1b4770084f0bbb523877aa4789389e21e628ddbc3db6780d355d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e8e191643ac0d4592595de0d0a3f73c268f3c9a73df85f48803b90e9ff64896"
    sha256 cellar: :any_skip_relocation, monterey:       "890667626cdd26e690f33356246145e3dd418993f8e11721253673f97af1dfe1"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7714d8bc524b27e694ba4d118604fb35574e72b53386011a7e3f2a928eed737"
    sha256 cellar: :any_skip_relocation, catalina:       "2d6b08879f86f1d7bc2017c25604dbe5824288b0ec0c7289be17db34ccff993f"
    sha256 cellar: :any_skip_relocation, mojave:         "916584cbeb899294bf3cd9122340db695f10f45368291b0728e712f91ba420f7"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"

  uses_from_macos "sqlite"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/86/ed/eb0468849a425a9ef0d15f789e2272bb5fc4081926f0261542927599177b/cli_helpers-2.2.0.tar.gz"
    sha256 "733f65d8c921e0cffa8f7ae4c8735bd7ecdffec383c5246f647ddd0fddb33448"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/15/e4/f138d6319c02a6052a590ef32e94366b74581973b43665c2960b07b9ec24/prompt_toolkit-3.0.24.tar.gz"
    sha256 "1bb05628c7d87b645974a1bad3f17612be0c29fa39af9f7688030163f680bad6"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/53/5345177cafa79a49e02c27102019a01ef1682ab170d2138deca47a4c8924/Pygments-2.11.1.tar.gz"
    sha256 "59b895e326f0fb0d733fd28c6839bd18ad0687ba20efc26d4277fd1d30b971f4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/32/fe/8a8575debfd924c8160295686a7ea661107fc34d831429cce212b6442edb/sqlparse-0.4.2.tar.gz"
    sha256 "0c00730c74263a94e5a9919ade150dfc3b19c574389985446148402998287dae"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".config/litecli/config").write <<~EOS
      [main]
      table_format = tsv
      less_chatty = True
    EOS

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE IF NOT EXISTS package_manager (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(256)
      );
      INSERT INTO
        package_manager (name)
      VALUES
        ('Homebrew');
    EOS
    system "/usr/bin/sqlite3 test.db < test.sql"

    require "pty"

    r, w, pid = PTY.spawn("#{bin}/litecli test.db")
    sleep 2
    w.puts "SELECT name FROM package_manager"
    w.puts "quit"
    output = r.read

    # remove ANSI colors
    output.gsub!(/\e\[([;\d]+)?m/, "")
    # normalize line endings
    output.gsub!(/\r\n/, "\n")

    expected = <<~EOS
      name
      Homebrew
      1 row in set
    EOS

    assert_match expected, output

    Process.wait(pid)
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
