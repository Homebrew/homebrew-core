require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-2.5.1.tgz"
  sha256 "f72cd468516ca42ce96894df3e6b9717c5755cb02cbebe30ba871f97164c52d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7bee18112e57131cd49a47e5dd04ceb41ac132616ac7b867e871a077d45a051"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7bee18112e57131cd49a47e5dd04ceb41ac132616ac7b867e871a077d45a051"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7bee18112e57131cd49a47e5dd04ceb41ac132616ac7b867e871a077d45a051"
    sha256 cellar: :any_skip_relocation, ventura:        "b96a83e08b7dc0bfd0d136d8f0d87af71564895763b69a91a77aa24b9ff30353"
    sha256 cellar: :any_skip_relocation, monterey:       "b96a83e08b7dc0bfd0d136d8f0d87af71564895763b69a91a77aa24b9ff30353"
    sha256 cellar: :any_skip_relocation, big_sur:        "b96a83e08b7dc0bfd0d136d8f0d87af71564895763b69a91a77aa24b9ff30353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5633dc2dfc2e8cf39a91581af67ace1131f8791d79f3ae801eea7d8a768d040"
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
