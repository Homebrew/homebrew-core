class MysqlToSqlite3 < Formula
  include Language::Python::Virtualenv

  desc "Transfer data from MySQL to SQLite"
  homepage "https://github.com/techouse/mysql-to-sqlite3"
  url "https://files.pythonhosted.org/packages/1e/a1/937179788587d490a94fb8968fc151d118c1b07b67c3503767b9b6b775d8/mysql_to_sqlite3-2.6.0.tar.gz"
  sha256 "b465354a82205a23523d4886ae76579872d266f0444ff5c4d5f89dcb858ce253"
  license "MIT"
  head "https://github.com/techouse/mysql-to-sqlite3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4825a2380b120c8bf859a0d7db8fcfcae8b2ff7e7c0b614769bec49416a2f22e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fd56290b2ffd676fa49dff3aafb7627060a0b21bdff24fc346bb8a131e9abee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb9674b9665e48a183362ed119992c2e15e0b66bf9d86d94b331f3ede7984f3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e14604fab9979ff9c2d9c8fc859789029f3fc06f1fc62b2e7c2ae620ab8d5f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b04f189a272fa78a5c736cd3226de04a588b7920cc182c0f43a689126af9652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4407f7b036722c30fae2b7662b790e40ed9bb6c201fecbaffa4a2d1c22227223"
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
    url "https://files.pythonhosted.org/packages/f8/9b/af8fcaca1b0821349ef4f88e2775e059bcd7640900bca6533832f1fb845d/sqlglot-30.4.3.tar.gz"
    sha256 "3a4e9a1e1dd47f8e536ba822d77cb784681704da5e4a3e1a07d2ef86b6067826"
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
