require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.4.3.tgz"
  sha256 "fd865092dcd40720455edfd457edc7bb641b63859db94aaecad8add94faca3b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "158d77440f77e23a21e5b6763961f54cfb0b77280c9fd71e868872787c78e561"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "158d77440f77e23a21e5b6763961f54cfb0b77280c9fd71e868872787c78e561"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "158d77440f77e23a21e5b6763961f54cfb0b77280c9fd71e868872787c78e561"
    sha256 cellar: :any_skip_relocation, sonoma:         "86a9aaaf5a69584b3a2b96087bda7bcc3fffbd47debf1f5215d9c1a387015b2d"
    sha256 cellar: :any_skip_relocation, ventura:        "86a9aaaf5a69584b3a2b96087bda7bcc3fffbd47debf1f5215d9c1a387015b2d"
    sha256 cellar: :any_skip_relocation, monterey:       "86a9aaaf5a69584b3a2b96087bda7bcc3fffbd47debf1f5215d9c1a387015b2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35b74f7010e04d8865c439cccd16eb5fde2d2df2aa3726c43a78b7d9f21fca25"
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
