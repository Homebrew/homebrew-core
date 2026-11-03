class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-11.0.1.tgz"
  sha256 "90929a0009a6f902fddf19392a0a37df49ca755d10e3421e503eeeae1e2910e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "30613eee9f17bc883652c4a58af4bf6bcc05546bc22584a9246bf6daec4ecb1b"
    sha256 cellar: :any,                 arm64_tahoe:       "30613eee9f17bc883652c4a58af4bf6bcc05546bc22584a9246bf6daec4ecb1b"
    sha256 cellar: :any,                 arm64_sequoia:     "30613eee9f17bc883652c4a58af4bf6bcc05546bc22584a9246bf6daec4ecb1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "886dfca108f21d12e15a38451f6e686baa91a8cbb82d12270fb5c9fce935662d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b1efd6d60e27ae1449dd43f428184792a11cc69266b729a79c1970bbffe1c7d8"
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
