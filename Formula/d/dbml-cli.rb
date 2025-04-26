class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.13.0.tgz"
  sha256 "b90a91d707c7689c1ac447b8da1a8a633cb72e6e099708ac240bab0954eed37b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ddeb559b365eb1812f33b2a4a273ff682b48c99e1436bd8c33637e86b335614"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ddeb559b365eb1812f33b2a4a273ff682b48c99e1436bd8c33637e86b335614"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ddeb559b365eb1812f33b2a4a273ff682b48c99e1436bd8c33637e86b335614"
    sha256 cellar: :any_skip_relocation, sonoma:        "974dc0db8d6b6988e1ae08f25303e894cdf14a42534aead41081eef0216e475f"
    sha256 cellar: :any_skip_relocation, ventura:       "974dc0db8d6b6988e1ae08f25303e894cdf14a42534aead41081eef0216e475f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ddeb559b365eb1812f33b2a4a273ff682b48c99e1436bd8c33637e86b335614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ddeb559b365eb1812f33b2a4a273ff682b48c99e1436bd8c33637e86b335614"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    sql_file = testpath/"test.sql"
    sql_file.write <<~SQL
      CREATE TABLE "staff" (
        "id" INT PRIMARY KEY,
        "name" VARCHAR,
        "age" INT,
        "email" VARCHAR
      );
    SQL

    expected_dbml = <<~SQL
      Table "staff" {
        "id" INT [pk]
        "name" VARCHAR
        "age" INT
        "email" VARCHAR
      }
    SQL

    assert_match version.to_s, shell_output("#{bin}/dbml2sql --version")
    assert_equal expected_dbml, shell_output("#{bin}/sql2dbml #{sql_file}").chomp
  end
end
