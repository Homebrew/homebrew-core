class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-3.12.0.tgz"
  sha256 "40f9714c962340b533ee6f18d3f286c63518041be8665ff82e388147eb28426b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbca250bbe9d21f8fbe73b6c681178320fb767a76afa9fa73c70c75a751c7433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbca250bbe9d21f8fbe73b6c681178320fb767a76afa9fa73c70c75a751c7433"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbca250bbe9d21f8fbe73b6c681178320fb767a76afa9fa73c70c75a751c7433"
    sha256 cellar: :any_skip_relocation, sonoma:        "d05a89607967689a7f971e2fd6800dff10ac632f402027d606cb2dde544af954"
    sha256 cellar: :any_skip_relocation, ventura:       "d05a89607967689a7f971e2fd6800dff10ac632f402027d606cb2dde544af954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbca250bbe9d21f8fbe73b6c681178320fb767a76afa9fa73c70c75a751c7433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbca250bbe9d21f8fbe73b6c681178320fb767a76afa9fa73c70c75a751c7433"
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
