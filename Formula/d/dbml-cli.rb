class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-5.4.1.tgz"
  sha256 "ba7221e7994b1b8ef87d8a43d491b1ad0098357b07e4ae47f0a1a965fde547c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b05d7f446a32750611c927fe7e41b70416ea397be68a07825ee1a73b08003ad"
    sha256 cellar: :any,                 arm64_sequoia: "925d837aa8d2937338ce4c8b85220b52e6ab5bf3c45d4343cfbe4b1536e9f179"
    sha256 cellar: :any,                 arm64_sonoma:  "925d837aa8d2937338ce4c8b85220b52e6ab5bf3c45d4343cfbe4b1536e9f179"
    sha256 cellar: :any,                 sonoma:        "331ea093c557ed3936f17271a683cf1320c0ff6e5a9292e3f7f51b114a76fd61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfba7cc733841a90f2690c905fd3dc869ebd8860bae2cb048c54767d078060a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55814929edf9ebf7967b0cd29c83f032d9e5918fa4522d87d545c79bf6ad2eb5"
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
