class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-10.1.1.tgz"
  sha256 "a7c188851bb7c62e9a0be69a710be7b31c61c35aeed07a3e3d5f75659ad00855"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a389208232134ba9e3a84f1061f75aaf8a69fe2e36dc97d0973cb515a0738f39"
    sha256 cellar: :any,                 arm64_sequoia: "a389208232134ba9e3a84f1061f75aaf8a69fe2e36dc97d0973cb515a0738f39"
    sha256 cellar: :any,                 arm64_sonoma:  "a389208232134ba9e3a84f1061f75aaf8a69fe2e36dc97d0973cb515a0738f39"
    sha256 cellar: :any,                 sonoma:        "70bd7016dc60f4bc9104a2721cf204318c0e15a5c8be90cc6d732f135de76b1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7488cac965b2261dfe34c67bacfa5a8192f0539700514d14d1cbd76a8907af45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86c5499127c749c17f7f3a5c7204898a788ad8f783ab2eab0f2bae914d663e91"
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
