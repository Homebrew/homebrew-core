class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-13.0.0.tgz"
  sha256 "662acda47691cf9c39ddb302062b51aca96f735021591f0e8e0b7dac8a594efe"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "431e53f0361a91b50aece00590384598d984b89800e307fb0b0356c7aaeeabcc"
    sha256 cellar: :any,                 arm64_golden_gate: "f64cb797165ec8853ef47d3b9ccf221bc78dac2ec2cdd66c6f86c4a54702cb87"
    sha256 cellar: :any,                 arm64_tahoe:       "f64cb797165ec8853ef47d3b9ccf221bc78dac2ec2cdd66c6f86c4a54702cb87"
    sha256 cellar: :any,                 arm64_sequoia:     "f64cb797165ec8853ef47d3b9ccf221bc78dac2ec2cdd66c6f86c4a54702cb87"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0e25cfaaa1377bcfbcafd9d2a020e3972ee5c71077e66940d4841aded3b1275f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "30ee5df6d321919e1fb62d09c5e34700855514c6e540c957a7259dd7c12e1f25"
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
