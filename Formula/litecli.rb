class Litecli < Formula
  include Language::Python::Virtualenv

  desc "CLI for SQLite Databases with auto-completion and syntax highlighting"
  homepage "https://github.com/dbcli/litecli"
  url "https://files.pythonhosted.org/packages/cd/c2/4a061e7d6aeec8ae0a8da1da77827cd100b0199adf3f9ac771fdc585621d/litecli-1.6.0.tar.gz"
  sha256 "4d274e1475b4d3bb32384838830bc4a8388992b7cb8119aa8cffc7ffaa0167f9"
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
    url "https://files.pythonhosted.org/packages/3f/3f/6ecd0ddf2394b698dd82ff3ddbcda235f8d6dadf124af6222eff49b32e87/cli_helpers-2.1.0.tar.gz"
    sha256 "dd6f164310f7d86fa3da1f82043a9c784e44a02ad49be932a80624261e56979b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/3e/8c/9b93fd9ae393a41c92c1a5b9042a048ef4650853ca6ff9e0818781a01e2f/prompt_toolkit-3.0.17.tar.gz"
    sha256 "9397a7162cf45449147ad6042fa37983a081b8a73363a5253dd4072666333137"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/9d/bc9047ca1eee944cc245f3649feea6eecde3f38011ee9b8a6a64fb7088cd/Pygments-2.8.1.tar.gz"
    sha256 "2656e1a6edcdabf4275f9a3640db59fd5de107d88e8663c5d4e9a0fa62f77f94"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/a2/54/da10f9a0235681179144a5ca02147428f955745e9393f859dec8d0d05b41/sqlparse-0.4.1.tar.gz"
    sha256 "0f91fd2e829c44362cbcfab3e9ae12e22badaa8a29ad5ff599f9ec109f0454e8"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
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
