require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-2.4.2.tgz"
  sha256 "828bbe97dee54623c3f0fe05066fa7b0694bfcc1197b8a849a7108b387fb9b56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34395513751f86d0671d5f34ac6a4d09f925dc6af204e546a000eaa6f5577987"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34395513751f86d0671d5f34ac6a4d09f925dc6af204e546a000eaa6f5577987"
    sha256 cellar: :any_skip_relocation, monterey:       "d0d1e9088611ba921d8c322e7990a8002e3eca202c56e090a5965faf3666b9b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0d1e9088611ba921d8c322e7990a8002e3eca202c56e090a5965faf3666b9b3"
    sha256 cellar: :any_skip_relocation, catalina:       "d0d1e9088611ba921d8c322e7990a8002e3eca202c56e090a5965faf3666b9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb12cd658cc92f41d779e76f8c8a849499d227f3b9bb5b3ce54b7b33cc9e120c"
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
