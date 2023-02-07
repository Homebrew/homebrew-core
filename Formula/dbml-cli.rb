require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-2.5.0.tgz"
  sha256 "8b1eb615bef09ab259fded29795409ef4f29beafdd2aad4400906d14cae62a18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b76584272e842b679a948c0afebd9abf0e09d7c45f5bd5859c66426744b68532"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b76584272e842b679a948c0afebd9abf0e09d7c45f5bd5859c66426744b68532"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b76584272e842b679a948c0afebd9abf0e09d7c45f5bd5859c66426744b68532"
    sha256 cellar: :any_skip_relocation, ventura:        "f9a5c6ea0e99d609ffb466f095b82d7419be897db29b924f83f8f7139ddeaee2"
    sha256 cellar: :any_skip_relocation, monterey:       "f83ddfc7a1c85b213f1e06635b71d75dfb8830dc242906b4b5735130e4db59c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f83ddfc7a1c85b213f1e06635b71d75dfb8830dc242906b4b5735130e4db59c3"
    sha256 cellar: :any_skip_relocation, catalina:       "f83ddfc7a1c85b213f1e06635b71d75dfb8830dc242906b4b5735130e4db59c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6225a184c5eda78c7438e4d62a9b6df9ab538b8f6b070660d33c62ae3b99394"
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
