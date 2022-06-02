require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-2.4.2.tgz"
  sha256 "828bbe97dee54623c3f0fe05066fa7b0694bfcc1197b8a849a7108b387fb9b56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e813a5ed4c64ada675c10a639b581e91546aed656278c9e23853d9cbe7daa2ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e813a5ed4c64ada675c10a639b581e91546aed656278c9e23853d9cbe7daa2ae"
    sha256 cellar: :any_skip_relocation, monterey:       "22c543ffd72019c6ce39104e0e359c3d368939623edfec8a11fe8a330e432f47"
    sha256 cellar: :any_skip_relocation, big_sur:        "22c543ffd72019c6ce39104e0e359c3d368939623edfec8a11fe8a330e432f47"
    sha256 cellar: :any_skip_relocation, catalina:       "22c543ffd72019c6ce39104e0e359c3d368939623edfec8a11fe8a330e432f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f7a426f76fdf7d261bb6c99c3b2798f76f1950a878e6025c72a5e80b892643a"
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
