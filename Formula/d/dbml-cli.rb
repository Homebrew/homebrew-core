class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-8.2.5.tgz"
  sha256 "881d27fe4f7ba8aa78d661765a996099a61e9b7bc40950d03556055fb06b5928"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "65a09926c75e34e1137341d45a1949e97d84b821d44f12534d983862ee64f449"
    sha256 cellar: :any,                 arm64_sequoia: "f8e4cd0d787beba2139e6f0f590402ce7513ee1bb6274b1a577f5b240c3ce4f9"
    sha256 cellar: :any,                 arm64_sonoma:  "f8e4cd0d787beba2139e6f0f590402ce7513ee1bb6274b1a577f5b240c3ce4f9"
    sha256 cellar: :any,                 sonoma:        "c7023045e81952d42fa9dd5f7701b70bdeab6489b00eee70b867b2ab6db6fdca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "085cf4d19cf95489fc5852609402e9ab7a8d817170687cde6c7dbdca189fae6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0bbb196184da127fda410e0bf2b618b6d14697513e9bb8fcff308a914036c4d"
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
