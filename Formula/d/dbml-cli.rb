require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.4.1.tgz"
  sha256 "5914474ace97057a8296973c36649d2a3180903290c696b2d7b123884a12f9ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26bf51cf63b4df225b6eae2036637d0345c46cc93ff598d479e8a062d27d0639"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26bf51cf63b4df225b6eae2036637d0345c46cc93ff598d479e8a062d27d0639"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26bf51cf63b4df225b6eae2036637d0345c46cc93ff598d479e8a062d27d0639"
    sha256 cellar: :any_skip_relocation, sonoma:         "4da2debce7421828a913daa7794eee5590bb49a404fbcc9b37a28b78e63d3d0c"
    sha256 cellar: :any_skip_relocation, ventura:        "4da2debce7421828a913daa7794eee5590bb49a404fbcc9b37a28b78e63d3d0c"
    sha256 cellar: :any_skip_relocation, monterey:       "4da2debce7421828a913daa7794eee5590bb49a404fbcc9b37a28b78e63d3d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26bf51cf63b4df225b6eae2036637d0345c46cc93ff598d479e8a062d27d0639"
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
