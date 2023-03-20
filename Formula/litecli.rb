class Litecli < Formula
  include Language::Python::Virtualenv

  desc "CLI for SQLite Databases with auto-completion and syntax highlighting"
  homepage "https://github.com/dbcli/litecli"
  url "https://files.pythonhosted.org/packages/c1/92/b2eb5f098446a05b9a92e548bd83442f2169f87f3e1b37ffed7a5315c264/litecli-1.9.0.tar.gz"
  sha256 "21af2cfa083dd4df1e3ccaa2a2117129b5f17212756f596ea090e296776c27a1"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5da1f7dea09d44b2ff9affbb2775f0df78e3db5bcbcfb540ff4f2d5994fd1e1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39e05aef55a4bef5cedb2392bd231bac77248ef16ddb9868512b2bcdf4d9dba7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24f74a7040bf91fe5de379c5d6e884281d50e6f5948955fd7299e2b35ed945d4"
    sha256 cellar: :any_skip_relocation, ventura:        "d4a559e3d03bd4baf95b33cd915d0e6aff3ae2af7f0ff78029a5697ab075080b"
    sha256 cellar: :any_skip_relocation, monterey:       "0e56976717e0a01cd33f6e575f52087476035d90cefe7b1cefe0feacc41905d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6cd645d981824e518484b523d67ec2ccd2b590f642a1f13e7a1e6edc5282e8d"
    sha256 cellar: :any_skip_relocation, catalina:       "05a5004d955ef6fef211ecdfce7c8bdc16ae78fad89caffdb78c15c01692b1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b01d5f27e46df045d675b99812fd38741e4b603b8c31e031b4817c1e66a4c8b"
  end

  depends_on "pygments"
  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "sqlite"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/27/01/6aaa4fc415274ac77372b4d259c234b9f5bfc8d78144c3fda1f3019d4690/cli_helpers-2.3.0.tar.gz"
    sha256 "e7174d003a2b58fd3e31a73fbbc45d5aa513de62cbd42d437f78b9658bd5f967"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/e2/d9/1009dbb3811fee624af34df9f460f92b51edac528af316eb5770f9fbd2e1/prompt_toolkit-3.0.32.tar.gz"
    sha256 "e7f2129cba4ff3b3656bbdda0e74ee00d2f874a8bcdb9dd16f5fec7b3e173cae"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/ba/fa/5b7662b04b69f3a34b8867877e4dbf2a37b7f2a5c0bbb5a9eed64efd1ad1/sqlparse-0.4.3.tar.gz"
    sha256 "69ca804846bb114d2ec380e4360a8a340db83f0ccf3afceeb1404df028f57268"
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
    system "sqlite3 test.db < test.sql"

    require "pty"
    output = ""
    PTY.spawn("#{bin}/litecli test.db") do |r, w, _pid|
      sleep 2
      w.puts "SELECT name FROM package_manager"
      w.puts "quit"

      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

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
  end
end
