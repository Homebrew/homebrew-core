class Litecli < Formula
  include Language::Python::Virtualenv

  desc "CLI for SQLite Databases with auto-completion and syntax highlighting"
  homepage "https://github.com/dbcli/litecli"
  url "https://files.pythonhosted.org/packages/f4/87/94afa9501babb6b1801fa51581689d1854092d5bf949d0aced2327616a65/litecli-1.10.1.tar.gz"
  sha256 "37e6801f6be00d5d5853b8881db1ffdbbe9b0817c6c61bb2d9c7962f6cffa08f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3526222ee5dbbebb1f71db8924731a5aae4e0f20a281f7d9fa9a1f25b2f8dbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3526222ee5dbbebb1f71db8924731a5aae4e0f20a281f7d9fa9a1f25b2f8dbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3526222ee5dbbebb1f71db8924731a5aae4e0f20a281f7d9fa9a1f25b2f8dbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3526222ee5dbbebb1f71db8924731a5aae4e0f20a281f7d9fa9a1f25b2f8dbf"
    sha256 cellar: :any_skip_relocation, ventura:        "e3526222ee5dbbebb1f71db8924731a5aae4e0f20a281f7d9fa9a1f25b2f8dbf"
    sha256 cellar: :any_skip_relocation, monterey:       "e3526222ee5dbbebb1f71db8924731a5aae4e0f20a281f7d9fa9a1f25b2f8dbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "408166ccb352b19594eb8c20c00c324d1c6f4e92a0d36989aeb6fcb61962a990"
  end

  depends_on "python@3.12"

  uses_from_macos "sqlite"

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/ab/de/79529bd31c1664415d9554c0c5029f2137afe9808f35637bbcca977d9022/cli_helpers-2.3.1.tar.gz"
    sha256 "b82a8983ceee21f180e6fd0ddb7ca8dae43c40e920951e3817f996ab204dae6a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
    sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
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
