class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.9.5.tgz"
  sha256 "561436a69d0aef2bcf59c32439251c4c727265286e84137453a60bb6c7ca0882"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf8d79fcf5aedd3d55ce7cc5539bde5c8100e3053c6d3649d5d1f86435eb19d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf8d79fcf5aedd3d55ce7cc5539bde5c8100e3053c6d3649d5d1f86435eb19d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf8d79fcf5aedd3d55ce7cc5539bde5c8100e3053c6d3649d5d1f86435eb19d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9596cb208ecbcf9a8c6038899cca88ca6098a826332a94f3bd9e6c17db35d135"
    sha256 cellar: :any_skip_relocation, ventura:       "9596cb208ecbcf9a8c6038899cca88ca6098a826332a94f3bd9e6c17db35d135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf8d79fcf5aedd3d55ce7cc5539bde5c8100e3053c6d3649d5d1f86435eb19d4"
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
