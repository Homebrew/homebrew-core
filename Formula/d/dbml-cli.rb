class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-11.1.0.tgz"
  sha256 "a4fbacafc38a5933660c17a06d092eb96064647850ded0aef0ede924331092d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "058950cb72a3096b367824e1ab55f6b4afc17cfbcbd36cf3b89a8052febacfe8"
    sha256 cellar: :any,                 arm64_tahoe:       "058950cb72a3096b367824e1ab55f6b4afc17cfbcbd36cf3b89a8052febacfe8"
    sha256 cellar: :any,                 arm64_sequoia:     "058950cb72a3096b367824e1ab55f6b4afc17cfbcbd36cf3b89a8052febacfe8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f8ffd98a26c59b84dba41fba17dec1bc0e9f9bdba47a423d684b5586bc816e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "712406ea0f285ae1de30d45abd3920907c4818568627129b95ba4e9c8e06a7fc"
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
