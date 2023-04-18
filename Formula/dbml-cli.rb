require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-2.5.3.tgz"
  sha256 "d314bc19651ed95412f6a9bad1a65a6e2d50a1fce8518ad6369bda437ed5c347"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc82025184be2387ba33821e7bead328ddcc87bf388c7023a841db390965365c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc82025184be2387ba33821e7bead328ddcc87bf388c7023a841db390965365c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc82025184be2387ba33821e7bead328ddcc87bf388c7023a841db390965365c"
    sha256 cellar: :any_skip_relocation, ventura:        "e0a90adea60a874e4e6c5774e14f12decf435c5d06965a1db2696d7e6147e159"
    sha256 cellar: :any_skip_relocation, monterey:       "e0a90adea60a874e4e6c5774e14f12decf435c5d06965a1db2696d7e6147e159"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0a90adea60a874e4e6c5774e14f12decf435c5d06965a1db2696d7e6147e159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3e931422a6d4309f77080a3e55b346e2dc1987f5914edca9ed11e35948470ba"
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
