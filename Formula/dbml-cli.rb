require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-2.5.1.tgz"
  sha256 "f72cd468516ca42ce96894df3e6b9717c5755cb02cbebe30ba871f97164c52d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2dcc8c46db4e6603f3c2b90bec64d51fb42c2cf603aa471a6d672fcd1f1b0fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2dcc8c46db4e6603f3c2b90bec64d51fb42c2cf603aa471a6d672fcd1f1b0fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2dcc8c46db4e6603f3c2b90bec64d51fb42c2cf603aa471a6d672fcd1f1b0fb"
    sha256 cellar: :any_skip_relocation, ventura:        "bb484f814d7f09259612125bd5ff387cf60746779f0bfa0324bb1e5f91165a36"
    sha256 cellar: :any_skip_relocation, monterey:       "bb484f814d7f09259612125bd5ff387cf60746779f0bfa0324bb1e5f91165a36"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb484f814d7f09259612125bd5ff387cf60746779f0bfa0324bb1e5f91165a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e75a022791c7b438ffd4a2a5ccf2013087647fea8ba488852585b49f79b8c64"
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
