require "language/node"

class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.3.0.tgz"
  sha256 "1e3d05625cc6c13b4e84fdb42dbcc67918e7e11dd5140be8b974b2ec3c2bb07d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbd8abe69acb4d460b1f68ec79faa73bb5816471ac581f5a1a1812132216b356"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbd8abe69acb4d460b1f68ec79faa73bb5816471ac581f5a1a1812132216b356"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbd8abe69acb4d460b1f68ec79faa73bb5816471ac581f5a1a1812132216b356"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0cf31126315d807c892247508275203ca3f153babf6f841718ccfc83df8c448"
    sha256 cellar: :any_skip_relocation, ventura:        "e0cf31126315d807c892247508275203ca3f153babf6f841718ccfc83df8c448"
    sha256 cellar: :any_skip_relocation, monterey:       "e0cf31126315d807c892247508275203ca3f153babf6f841718ccfc83df8c448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c32019005245932851d502b8f784ab44a467baff3574ddd885833801325b219"
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
