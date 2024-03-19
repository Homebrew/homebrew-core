require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.4.0.tgz"
  sha256 "b26ab04d16e04c78a0c949a38656bbb5df2b116e058f26b606469fda85b7f0d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f65ae6b1f4571fdc42674b1b09ade84fa0da530fc7df38f2434a41bdf99a85cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f65ae6b1f4571fdc42674b1b09ade84fa0da530fc7df38f2434a41bdf99a85cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e47523c1a3b5c8746861a651700c5bd3afc4bb37d6d529f0a4e2d0e4357452db"
    sha256 cellar: :any_skip_relocation, sonoma:         "f40a72d069e095e8548889e90b0925f91171ed9a93222cb663b3b32cd4f9804b"
    sha256 cellar: :any_skip_relocation, ventura:        "f40a72d069e095e8548889e90b0925f91171ed9a93222cb663b3b32cd4f9804b"
    sha256 cellar: :any_skip_relocation, monterey:       "f40a72d069e095e8548889e90b0925f91171ed9a93222cb663b3b32cd4f9804b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fdfe2adee90e2d2be2493d4c03ea1bb7fe0fdc87836c57de302a39a10ef0f05"
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
