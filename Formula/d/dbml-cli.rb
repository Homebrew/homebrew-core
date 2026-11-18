class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-12.1.0.tgz"
  sha256 "eca98d3fe23a89f6721ffd478d50e307099874f31cdf687321f77f144e5011db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "245cbc940623059f2a8b51199e993e363778d4debf12545e6d6de6b32de8b149"
    sha256 cellar: :any,                 arm64_tahoe:       "245cbc940623059f2a8b51199e993e363778d4debf12545e6d6de6b32de8b149"
    sha256 cellar: :any,                 arm64_sequoia:     "245cbc940623059f2a8b51199e993e363778d4debf12545e6d6de6b32de8b149"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e90eec49750d43a278931ea867c958def15e7599f75845e03f3e139886bee02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9359d6b52ecfc2091ce2f02d45d6eff5bd91ae73f6cd7e4eb92d49cf1f542c38"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@dbml/cli/node_modules"
    node_modules.glob("oracledb/build/Release/oracledb-*.node").each do |f|
      rm(f) unless f.basename.to_s.match?("#{os}-#{arch}")
    end

    suffix = OS.linux? ? "-gnu" : ""
    node_modules.glob("snowflake-sdk/dist/lib/minicore/binaries/sf_mini_core_*.node").each do |f|
      rm(f) unless f.basename.to_s.match?("#{os}-#{arch}#{suffix}")
    end

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
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
