class MysqlToSqlite3 < Formula
  include Language::Python::Virtualenv

  desc "Transfer data from MySQL to SQLite"
  homepage "https://github.com/techouse/mysql-to-sqlite3"
  url "https://files.pythonhosted.org/packages/2c/93/989bff5d6aa8ac8851cea7b93058e51e4ca43dd28b5062ab3c23d9a36855/mysql_to_sqlite3-2.5.5.tar.gz"
  sha256 "59189d2cbf5d95c92c0b1649609d506751408a3915477e960d06b4d4251c8f27"
  license "MIT"
  head "https://github.com/techouse/mysql-to-sqlite3.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b341a36e832fc3a46a48a90060eb508c1fe73cc1c1a2f23dbe1d0748025817c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a44f7964a1ebb3b68c8c9fb20787a20fa13efc0a624dce9a646d2278f4062a7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dedcdbb2b119696b200b4b997628c50e902659ceb5100a66f39167a637b638e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7a222a6237cf63689051d1954dfe95418590d1047d028081d17f3a6358700d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "600d1b46fcde356958a1c552e03567b9c24d9eee87671ce8f0bca602c8559d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90bf6fe2cf156aff2a21d603652bad5e0e89145887c090844ca9d4d7ca831eeb"
  end

  depends_on "python@3.14"

  uses_from_macos "sqlite"

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "mysql-connector-python" do
    url "https://files.pythonhosted.org/packages/39/33/b332b001bc8c5ee09255a0d4b09a254da674450edd6a3e5228b245ca82a0/mysql_connector_python-9.5.0.tar.gz"
    sha256 "92fb924285a86d8c146ebd63d94f9eaefa548da7813bc46271508fdc6cc1d596"
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
    url "https://files.pythonhosted.org/packages/bf/8c/a4d24b6103305467506c1dea9c3ca8dc92773a91bae246c2517c256a0cf9/sqlglot-28.5.0.tar.gz"
    sha256 "b3213b3e867dcc306074f1c90480aeee89a0e635cf0dfe70eb4a3af7b61972e6"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
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
