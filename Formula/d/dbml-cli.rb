require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-2.6.1.tgz"
  sha256 "7d73b0eb96efb2c80f6d1b459ace5004f0a8b1d5e4c58fb76d35a42d1b227d70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d19e433766fa9752601d85a5401cb2cedbdedab0090a178c64592a7869a22a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d19e433766fa9752601d85a5401cb2cedbdedab0090a178c64592a7869a22a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d19e433766fa9752601d85a5401cb2cedbdedab0090a178c64592a7869a22a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f8cd55c5b5504bd8034df0d23976a68b3a9edfacc3a13a9a25327e6c672ff94"
    sha256 cellar: :any_skip_relocation, ventura:        "4f8cd55c5b5504bd8034df0d23976a68b3a9edfacc3a13a9a25327e6c672ff94"
    sha256 cellar: :any_skip_relocation, monterey:       "4f8cd55c5b5504bd8034df0d23976a68b3a9edfacc3a13a9a25327e6c672ff94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d1b7ea44ddaae9b056e59323808c85db4a17d2058b9bae6cab529a80fe8bf3d"
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
