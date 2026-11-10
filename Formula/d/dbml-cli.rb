class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-12.0.0.tgz"
  sha256 "b6e07a61ec64b8e1b389684b08df0884b0590f0f870ace92b1afa9427d5ea404"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "2e3ddb768dc164e9428c46efb44770f67f57bb6976ffd5d036a8b3fcc2ac1d53"
    sha256 cellar: :any,                 arm64_tahoe:       "2e3ddb768dc164e9428c46efb44770f67f57bb6976ffd5d036a8b3fcc2ac1d53"
    sha256 cellar: :any,                 arm64_sequoia:     "2e3ddb768dc164e9428c46efb44770f67f57bb6976ffd5d036a8b3fcc2ac1d53"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f26bf1239b28b5b066e804ecca4e92a3b134c7237987c615601c3f480192cca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bda3c65be4936eef1d0676147c347fc5d9b395bb527c15bf491a82ed8e9e8ee7"
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
