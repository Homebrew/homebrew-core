require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.5.0.tgz"
  sha256 "44ecbdf432abe97d825b227afb02759f1e3cdfb602354ffab95b3a36f0a9dfaf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f1445788c30a5230e796f11ef7359b0316a47c5bf2aa1619d458d88e75a618e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f1445788c30a5230e796f11ef7359b0316a47c5bf2aa1619d458d88e75a618e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f1445788c30a5230e796f11ef7359b0316a47c5bf2aa1619d458d88e75a618e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1eea308d09e1490ccf1fcf46dcde0d2e49bb14fd779815c93f9d3bf81893781c"
    sha256 cellar: :any_skip_relocation, ventura:        "1eea308d09e1490ccf1fcf46dcde0d2e49bb14fd779815c93f9d3bf81893781c"
    sha256 cellar: :any_skip_relocation, monterey:       "1eea308d09e1490ccf1fcf46dcde0d2e49bb14fd779815c93f9d3bf81893781c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cadbebc61f5632c87d48e37d6b043f713e49bc3ee704aab88a5efdbf1525a7ee"
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
