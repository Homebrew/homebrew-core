class Litecli < Formula
  include Language::Python::Virtualenv

  desc "CLI for SQLite Databases with auto-completion and syntax highlighting"
  homepage "https://github.com/dbcli/litecli"
  url "https://files.pythonhosted.org/packages/f3/8e/2530fef1b2b63d4d59e89fea9d0bed8f204d1b7514e06b8be18c372a2be3/litecli-1.10.0.tar.gz"
  sha256 "ee9e2a93d193a555c0e661ed083943a6f932a9c8e8c267b689b469f9ac7a3e0c"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d30b5150aafcb6b1de022478f2543f4fc09e9e464c93c7d7d23f70a108396b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4d5bb87fd5549ef2482d0fab7fbe0ce108131fc79ba097c6c5de8ee5609527f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4713d3290f8c2bca809c3cfddd8311330c8811798716a11f06af7917f05cb2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b022b71f6446bd39e412418b44594a72480f4f1d1a94b731d1febe6bd46bc5f"
    sha256 cellar: :any_skip_relocation, ventura:        "3ac2d8cb9f52d6347ea7ce9a0e516e45e2dc6ded90b5f1c307848b76c24b9304"
    sha256 cellar: :any_skip_relocation, monterey:       "f7033105796fc518c81ecd070f3ead605f226f9b640a683f48a552eaacde70ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f921bde07b395ef7f4b88d8d427e5ab1bbd6f99413fa14e40218c1e59d26256a"
  end

  depends_on "pygments"
  depends_on "python-click"
  depends_on "python-tabulate"
  depends_on "python@3.12"
  depends_on "six"
  depends_on "sqlparse"

  uses_from_macos "sqlite"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/27/01/6aaa4fc415274ac77372b4d259c234b9f5bfc8d78144c3fda1f3019d4690/cli_helpers-2.3.0.tar.gz"
    sha256 "e7174d003a2b58fd3e31a73fbbc45d5aa513de62cbd42d437f78b9658bd5f967"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/d9/7b/7d88d94427e1e179e0a62818e68335cf969af5ca38033c0ca02237ab6ee7/prompt_toolkit-3.0.41.tar.gz"
    sha256 "941367d97fc815548822aa26c2a269fdc4eb21e9ec05fc5d447cf09bad5d75f0"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2e/1c/21f2379555bba50b54e5a965d9274602fe2bada4778343d5385840f7ac34/wcwidth-0.2.10.tar.gz"
    sha256 "390c7454101092a6a5e43baad8f83de615463af459201709556b6e4b1c861f97"
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
    output.gsub!("\r\n", "\n")

    expected = <<~EOS
      name
      Homebrew
      1 row in set
    EOS

    assert_match expected, output
  end
end
