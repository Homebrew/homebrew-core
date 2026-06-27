class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-8.3.0.tgz"
  sha256 "8ffccc985dc37565ea5fe689431fa386b112032d43682aa7e7a68af73c5a1a3b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f63538b5d477d0ffc8b5ed3c765b413576ff6523c1a3d6705bebc9c6ec5acb4"
    sha256 cellar: :any,                 arm64_sequoia: "e515a5632ccd9817468461bf773549c117dbffcbd496b81f07da26d50c606ddb"
    sha256 cellar: :any,                 arm64_sonoma:  "e515a5632ccd9817468461bf773549c117dbffcbd496b81f07da26d50c606ddb"
    sha256 cellar: :any,                 sonoma:        "e581c20fcd87a7d923886dd3a9a631a552d2b7e02dcf63d8ad87bc4a649af648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b7b70e89ad199b61aa276e6e4f7c6da7349f5e9133277db5d5de989dc4083f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e05252ce10f8462b6b8f9a0e716d0f25192ba5b9f8910d80730f6344758f9efa"
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
