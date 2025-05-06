class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.13.4.tgz"
  sha256 "3484fc287598b715bc922ce959782694e480df80d0e4c046d02ee6aba38e45c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "634e925fef3d7224d5f50536307573363614739d6c123bd59b93b0982d486c7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "634e925fef3d7224d5f50536307573363614739d6c123bd59b93b0982d486c7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "634e925fef3d7224d5f50536307573363614739d6c123bd59b93b0982d486c7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bc879cb4c67a28f0f5b8e9c2e06300533f713d25925541c5f31a8d694542206"
    sha256 cellar: :any_skip_relocation, ventura:       "7bc879cb4c67a28f0f5b8e9c2e06300533f713d25925541c5f31a8d694542206"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "634e925fef3d7224d5f50536307573363614739d6c123bd59b93b0982d486c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "634e925fef3d7224d5f50536307573363614739d6c123bd59b93b0982d486c7e"
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
