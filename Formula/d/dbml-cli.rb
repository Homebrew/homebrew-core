require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.5.1.tgz"
  sha256 "3e260a3c49a1e57309c04ba40e08423e0eb3d73b40557df94f5dbfabd2493c1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04be77206ea8a4881c2e877b8a35b4243d1fcae7bac1b8cda559b2c8b5c40a38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04be77206ea8a4881c2e877b8a35b4243d1fcae7bac1b8cda559b2c8b5c40a38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04be77206ea8a4881c2e877b8a35b4243d1fcae7bac1b8cda559b2c8b5c40a38"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8fad2d4c800617ade922a7056f4361f2ca7e806ee138447a745101208fd5e8d"
    sha256 cellar: :any_skip_relocation, ventura:        "b8fad2d4c800617ade922a7056f4361f2ca7e806ee138447a745101208fd5e8d"
    sha256 cellar: :any_skip_relocation, monterey:       "b8fad2d4c800617ade922a7056f4361f2ca7e806ee138447a745101208fd5e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89ab6445dd6aa531649dca56ce122e8e612ba79cec4f18dc7cc207741fc8f565"
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
