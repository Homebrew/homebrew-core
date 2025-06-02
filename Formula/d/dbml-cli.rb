class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.13.5.tgz"
  sha256 "d981fa4e82ce33b140f1efa2e057f12dca83d25774b58dc5ed2ed92fb9ba2569"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb40548dd4f2155051c5ca300e1edc8cf5aeb254b032233fe20afd34eb2eee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbb40548dd4f2155051c5ca300e1edc8cf5aeb254b032233fe20afd34eb2eee8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbb40548dd4f2155051c5ca300e1edc8cf5aeb254b032233fe20afd34eb2eee8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f48ac3665d9f77e9886340a6723f2f1ab4a274b8023cb7998e3e6a3f7f6d8de8"
    sha256 cellar: :any_skip_relocation, ventura:       "f48ac3665d9f77e9886340a6723f2f1ab4a274b8023cb7998e3e6a3f7f6d8de8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbb40548dd4f2155051c5ca300e1edc8cf5aeb254b032233fe20afd34eb2eee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb40548dd4f2155051c5ca300e1edc8cf5aeb254b032233fe20afd34eb2eee8"
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
