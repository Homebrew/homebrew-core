class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-13.1.0.tgz"
  sha256 "3786db70753e4862aff2a087b4a6ef3a9ea074bcf945156055d908899b22c97c"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "7912bd46c67056827ba5671803e1fe58a2fe2ae9e8392b1710e3bacde825fc50"
    sha256 cellar: :any,                 arm64_golden_gate: "2017e3f50634c615a293de85c99ae818934be3923316f033c4f53b1d4c72d3ac"
    sha256 cellar: :any,                 arm64_tahoe:       "2017e3f50634c615a293de85c99ae818934be3923316f033c4f53b1d4c72d3ac"
    sha256 cellar: :any,                 arm64_sequoia:     "2017e3f50634c615a293de85c99ae818934be3923316f033c4f53b1d4c72d3ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4c4e5b221aa2c58c7a48239c1fbd133f6c8dec9c34d049fc24a828dbba04530d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "16a63ff4c609d997973ec37bb61cfeeaba8983ade53818189bda4d1cd13fe51b"
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
