class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-8.3.1.tgz"
  sha256 "5ebee3bc0b1d2aa61514d29da5e9025c90197f5a0c543c8b51f4c0a0392d0ba2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6fd12f5429c33d66e4926514da522f0fcb111dc0961c07721b00ccc4e6007e08"
    sha256 cellar: :any,                 arm64_sequoia: "f3e792a86c5ffd3c133f42cd1c0a19530fc04a4baa19a8c9bab768a804647a72"
    sha256 cellar: :any,                 arm64_sonoma:  "f3e792a86c5ffd3c133f42cd1c0a19530fc04a4baa19a8c9bab768a804647a72"
    sha256 cellar: :any,                 sonoma:        "bc51c4c3b1de0c2c0e855203b0bddd0d0558bbca1d2a4d913684848bd26f588f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbe7b21174c5ca3cc21a696c27cf2e62cc18f493ccc73b9967e0869aee5a2613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c35728b7bc6039b2ae9b24749562a063ae1c799bdeae4b3bdc84b010a568141"
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
