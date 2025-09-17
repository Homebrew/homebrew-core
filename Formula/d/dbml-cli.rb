class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.14.0.tgz"
  sha256 "c225aae5d390a1378bc1cded01e83ec8f8518350b229c4a6ca5b6667b89d8756"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a8b56b46480bdeb48d25857fe22d2e44c1c8bbe5518f905f5bfaacb9dc340ded"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    sql_file = testpath/"test.sql"
    sql_file.write <<~SQL
      CREATE TABLE "staff" (
        "id" INT PRIMARY KEY,
        "name" VARCHAR,
        "age" INT,
        "email" VARCHAR
      );
    SQL

    expected_dbml = <<~SQL
      Table "staff" {
        "id" INT [pk]
        "name" VARCHAR
        "age" INT
        "email" VARCHAR
      }
    SQL

    assert_match version.to_s, shell_output("#{bin}/dbml2sql --version")
    assert_equal expected_dbml, shell_output("#{bin}/sql2dbml #{sql_file}").chomp
  end
end
