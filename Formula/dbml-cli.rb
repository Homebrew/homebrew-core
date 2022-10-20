require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-2.4.3.tgz"
  sha256 "5384d221e8ea67c06e063b63a57c9031276b10420f179730dabe94be89e869c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1babde1b3da7e34d877dcc8248c43c348773db701e7228904db23caffa1b86cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1babde1b3da7e34d877dcc8248c43c348773db701e7228904db23caffa1b86cc"
    sha256 cellar: :any_skip_relocation, monterey:       "638a768bc89a530ed1045230c64bdff73f8bd46030f8154a9c4bc2985a2dfe88"
    sha256 cellar: :any_skip_relocation, big_sur:        "638a768bc89a530ed1045230c64bdff73f8bd46030f8154a9c4bc2985a2dfe88"
    sha256 cellar: :any_skip_relocation, catalina:       "638a768bc89a530ed1045230c64bdff73f8bd46030f8154a9c4bc2985a2dfe88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc5e9a1b54d4796ab27bb054076024e72923964d926f9ed6fcf91cef1b2a40d7"
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
