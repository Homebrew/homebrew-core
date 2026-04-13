class MysqlToSqlite3 < Formula
  include Language::Python::Virtualenv

  desc "Transfer data from MySQL to SQLite"
  homepage "https://github.com/techouse/mysql-to-sqlite3"
  url "https://files.pythonhosted.org/packages/e6/53/df9ea59dfcfe883f4778527fbb8746f7583e702a9fa0415aff3870b4771e/mysql_to_sqlite3-2.5.7.tar.gz"
  sha256 "ed749ad621bdf6246670ebf181d715a2ab1092efebe8cee0f9ac9e4b277dbebc"
  license "MIT"
  head "https://github.com/techouse/mysql-to-sqlite3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf221fbb9115d71cbdfc986e6738e6ba3a87b7f4baa9fd2e36cfe838d4bafeb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09f84d080cf0ad7cec1f705b66c79b5004468641071676bd1b772bdc950d9062"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c823d135e910184d6b4e450eb71da295b84d6e1a962b88762dda8665737eda7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "350d190a6da22a6b1b6e78eebe92cf681ebfe6a8d5d3cda392937132ad83e8ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa61435424be523f8d31f4f8418b1c73e0eb0650cd5c0f003718da2151ec62c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d1682e4249e3aa1c390ecadedcb1d4388db2511bf19ad6dfe46d463a407271a"
  end

  depends_on "python@3.14"

  uses_from_macos "sqlite"

  resource "click" do
    url "https://files.pythonhosted.org/packages/57/75/31212c6bf2503fdf920d87fee5d7a86a2e3bcf444984126f13d8e4016804/click-8.3.2.tar.gz"
    sha256 "14162b8b3b3550a7d479eafa77dfd3c38d9dc8951f6f69c78913a8f9a7540fd5"
  end

  resource "mysql-connector-python" do
    url "https://files.pythonhosted.org/packages/6f/6e/c89babc7de3df01467d159854414659c885152579903a8220c8db02a3835/mysql_connector_python-9.6.0.tar.gz"
    sha256 "c453bb55347174d87504b534246fb10c589daf5d057515bf615627198a3c7ef1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/87/c7/5e1547c44e31da50a460df93af11a535ace568ef89d7a811069ead340c4a/python-slugify-8.0.4.tar.gz"
    sha256 "59202371d1d05b54a9e7720c5e038f928f45daaffe41dd10822f3907b937c856"
  end

  resource "pytimeparse2" do
    url "https://files.pythonhosted.org/packages/19/10/cc63fecd69905eb4d300fe71bd580e4a631483e9f53fdcb8c0ad345ce832/pytimeparse2-1.7.1.tar.gz"
    sha256 "98668cdcba4890e1789e432e8ea0059ccf72402f13f5d52be15bdfaeb3a8b253"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/41/f4/a1ac5ed32f7ed9a088d62a59d410d4c204b3b3815722e2ccfb491fa8251b/simplejson-3.20.2.tar.gz"
    sha256 "5fe7a6ce14d1c300d80d08695b7f7e633de6cd72c80644021874d985b3393649"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/ff/5a/b8149963cd479a7e5b71f43d11d678f5e4b8633ab4de5b25e7a5d6eefa20/sqlglot-30.2.1.tar.gz"
    sha256 "ef4a67cc6f66a8043085eb8ea95fa9541c1625dffa9145ad4e9815a7ba60a199"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"mysql2sqlite", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql2sqlite --version")

    port = free_port
    dummy_sqlite_file = testpath/"dummy.sqlite"
    output = shell_output("#{bin}/mysql2sqlite --sqlite-file #{dummy_sqlite_file} " \
                          "--mysql-database nonexistent --mysql-user root --mysql-port #{port} 2>&1", 1)
    assert_match "Can't connect to MySQL server", output
  end
end
