class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.9.4.tgz"
  sha256 "d3530c464cc891b7ae9d98bdfeb3c2fe43347160d90881c933f2e916a0dbb3e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f73eec804ddce3f1aa9f2218e4cb932c42ef1c6cd6776a1a299a7e493dd65553"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f73eec804ddce3f1aa9f2218e4cb932c42ef1c6cd6776a1a299a7e493dd65553"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f73eec804ddce3f1aa9f2218e4cb932c42ef1c6cd6776a1a299a7e493dd65553"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ec1f249d4adf1a7b6dc0e06904978b8cbef844593983344192e98ca01c05bb2"
    sha256 cellar: :any_skip_relocation, ventura:       "3ec1f249d4adf1a7b6dc0e06904978b8cbef844593983344192e98ca01c05bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f73eec804ddce3f1aa9f2218e4cb932c42ef1c6cd6776a1a299a7e493dd65553"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
