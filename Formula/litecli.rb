class Litecli < Formula
  include Language::Python::Virtualenv

  desc "CLI for SQLite Databases with auto-completion and syntax highlighting"
  homepage "https://github.com/dbcli/litecli"
  url "https://files.pythonhosted.org/packages/03/08/a124a13cf2a7b85e1bce3def574a451b761f0546a391142c5d2426a6bdc4/litecli-1.4.1.tar.gz"
  sha256 "1404568ed6d2e738bf5d00f201522652602b2e3f31013cf58d9e239d715dab5c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a5c32ad08cf648a27f4227a318fcaa0703ae5997b0eb305ff1b5922825e114df" => :catalina
    sha256 "dad4c2dc18b9bd8d9902e021fc28772947e1fb99179edffa32218091ca330671" => :mojave
    sha256 "eb2ebf6ab934ad00fe09c41be58e5bbd6fb347d0f2a79fdf3108587b5a0db639" => :high_sierra
  end

  depends_on "python@3.8"

  uses_from_macos "sqlite" => :test

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
    url "https://files.pythonhosted.org/packages/69/19/3aa4bf17e1cbbdfe934eb3d5b394ae9a0a7fb23594a2ff27e0fdaf8b4c59/prompt_toolkit-3.0.5.tar.gz"
    sha256 "563d1a4140b63ff9dd587bda9557cffb2fe73650205ab6f4383092fb882e7dc8"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
    sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/67/4b/253b6902c1526885af6d361ca8c6b1400292e649f0e9c95ee0d2e8ec8681/sqlparse-0.3.1.tar.gz"
    sha256 "e162203737712307dfe78860cc56c8da8a852ab2ee33750e33aeadf38d12c548"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/57/6f/213d075ad03c84991d44e63b6516dd7d185091df5e1d02a660874f8f7e1e/tabulate-0.8.7.tar.gz"
    sha256 "db2723a20d04bcda8522165c73eea7c300eda74e0ce852d9022e0159d7895007"
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
    output.gsub! /\e\[([;\d]+)?m/, ""
    # normalize line endings
    output.gsub! /\r\n/, "\n"

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
