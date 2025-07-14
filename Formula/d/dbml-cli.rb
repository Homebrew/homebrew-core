class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.13.6.tgz"
  sha256 "e06a2a912fff560fb66f92c78c010b1c050645b03f9cc2cb2508d954a3c68692"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a49e8f7d447b4935c1759ea4f0c6dfcf4ce5d81499b9a1b14338cb82bf8abe91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a49e8f7d447b4935c1759ea4f0c6dfcf4ce5d81499b9a1b14338cb82bf8abe91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a49e8f7d447b4935c1759ea4f0c6dfcf4ce5d81499b9a1b14338cb82bf8abe91"
    sha256 cellar: :any_skip_relocation, sonoma:        "b53a388e5e78d05017afea90f4d0ab2f0235f4a7e2eb9d09e46fe9fc52cb103a"
    sha256 cellar: :any_skip_relocation, ventura:       "b53a388e5e78d05017afea90f4d0ab2f0235f4a7e2eb9d09e46fe9fc52cb103a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a49e8f7d447b4935c1759ea4f0c6dfcf4ce5d81499b9a1b14338cb82bf8abe91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a49e8f7d447b4935c1759ea4f0c6dfcf4ce5d81499b9a1b14338cb82bf8abe91"
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
