class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.9.0.tgz"
  sha256 "d896acd2a8cdb5e695fcfef7e1c5f9388e50daf56aea695209117247194184eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fb538717a61d72f23dad32191bcb4b48208d77b51773c8e3f644ca9c89b2033"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fb538717a61d72f23dad32191bcb4b48208d77b51773c8e3f644ca9c89b2033"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fb538717a61d72f23dad32191bcb4b48208d77b51773c8e3f644ca9c89b2033"
    sha256 cellar: :any_skip_relocation, sonoma:        "45ba3eeaee8fe6398f8089fec784e637e233ed3496d00aae890d7ac4d343c026"
    sha256 cellar: :any_skip_relocation, ventura:       "45ba3eeaee8fe6398f8089fec784e637e233ed3496d00aae890d7ac4d343c026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1143ea62e0ef33cae2515fb1c9da15dec83b3ae898272992a64dfc5b7470aafa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
