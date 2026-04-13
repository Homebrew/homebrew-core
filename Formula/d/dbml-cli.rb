class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-7.0.0.tgz"
  sha256 "47bfcf989a18d76251acd96990da7d2c16abff86071d06c26c7c041b73f3d74f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e95a6965e288f27961d96714dbff990a34f297f1c980ae0b86b5524b13699d6"
    sha256 cellar: :any,                 arm64_sequoia: "38617ab100ed506af1d99e3272071ccb46c5c5565f3cabc45820a07910b23329"
    sha256 cellar: :any,                 arm64_sonoma:  "38617ab100ed506af1d99e3272071ccb46c5c5565f3cabc45820a07910b23329"
    sha256 cellar: :any,                 sonoma:        "4fa590ef753a27e73d1e5607c58621f68392fecf8a30ee0b4f4d83dc5a400988"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fb1a18e9d5d48a6f03fd6b0fd17cbf8e57bb455147c29af6d83cfc3f2059c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "078a7cd508e9da38ec625aaebd55377a35192db22907ef3e9a804f124638b4fc"
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
