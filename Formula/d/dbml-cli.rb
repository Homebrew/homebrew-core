class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.9.2.tgz"
  sha256 "a4f84bd7d08e71634ded379c56d9f3bc023cf6ae90045204fd132e2fdae80b86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef2b4f4eb7b6314c68a127973281f1e60539dbb88de9b412ce116eef02e56879"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef2b4f4eb7b6314c68a127973281f1e60539dbb88de9b412ce116eef02e56879"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef2b4f4eb7b6314c68a127973281f1e60539dbb88de9b412ce116eef02e56879"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f50a042f3c147e668c97a4a1a98fe32fa213e2176e9ef9a329400eada44ea52"
    sha256 cellar: :any_skip_relocation, ventura:       "5f50a042f3c147e668c97a4a1a98fe32fa213e2176e9ef9a329400eada44ea52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef2b4f4eb7b6314c68a127973281f1e60539dbb88de9b412ce116eef02e56879"
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
