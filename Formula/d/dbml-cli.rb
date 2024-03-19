require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.3.0.tgz"
  sha256 "1e3d05625cc6c13b4e84fdb42dbcc67918e7e11dd5140be8b974b2ec3c2bb07d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "949dffd65783ada7d2af32b14c084b93283196844b2703af721a846c12eaeb74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "949dffd65783ada7d2af32b14c084b93283196844b2703af721a846c12eaeb74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "949dffd65783ada7d2af32b14c084b93283196844b2703af721a846c12eaeb74"
    sha256 cellar: :any_skip_relocation, sonoma:         "276c465cba45132e570c58f0b3b7d71d102b58ce0eb2a945e5ff532234a8241c"
    sha256 cellar: :any_skip_relocation, ventura:        "276c465cba45132e570c58f0b3b7d71d102b58ce0eb2a945e5ff532234a8241c"
    sha256 cellar: :any_skip_relocation, monterey:       "276c465cba45132e570c58f0b3b7d71d102b58ce0eb2a945e5ff532234a8241c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10e753c0924f9d38bd7f4a9d8929f43495d08a1f0bce1ae0215d78fe3f4c9933"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    sql_file = testpath/"test.sql"
    sql_file.write <<~EOS
      CREATE TABLE "staff" (
        "id" INT PRIMARY KEY,
        "name" VARCHAR,
        "age" INT,
        "email" VARCHAR
      );
    EOS

    expected_dbml = <<~EOS
      Table "staff" {
        "id" INT [pk]
        "name" VARCHAR
        "age" INT
        "email" VARCHAR
      }
    EOS

    assert_match version.to_s, shell_output("#{bin}/dbml2sql --version")
    assert_equal expected_dbml, shell_output("#{bin}/sql2dbml #{sql_file}").chomp
  end
end
