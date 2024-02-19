require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.1.5.tgz"
  sha256 "53c8695cbea7685e21178791f91c7f6812ed0c02c9d54120701dce7627b862d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d155a2e9c8c1eb926e05cd52f92fe147cd290f7f5b63ee166ea9babb55e09748"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d155a2e9c8c1eb926e05cd52f92fe147cd290f7f5b63ee166ea9babb55e09748"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d155a2e9c8c1eb926e05cd52f92fe147cd290f7f5b63ee166ea9babb55e09748"
    sha256 cellar: :any_skip_relocation, sonoma:         "00aca11d3dea195ac0edab26b3a71c10fbcf8cebe5f91517db0032f6ef3d4c43"
    sha256 cellar: :any_skip_relocation, ventura:        "00aca11d3dea195ac0edab26b3a71c10fbcf8cebe5f91517db0032f6ef3d4c43"
    sha256 cellar: :any_skip_relocation, monterey:       "00aca11d3dea195ac0edab26b3a71c10fbcf8cebe5f91517db0032f6ef3d4c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92455bef2fd9a929c42c3b1b818b985a81a66f6a1a5216ea133f2f1d4c6c5259"
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
