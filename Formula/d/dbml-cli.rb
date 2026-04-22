class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-7.1.1.tgz"
  sha256 "7507bd2b4d27d412d1e2fee9e4eb129cecd8764e603cdef8761b5aca14931706"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "10addd51977041700b0230e0e10e19264473d80ea527dbe75c292cede92c3525"
    sha256 cellar: :any,                 arm64_sequoia: "be655c3c5e48ae96fc96181b7d80b52c83405fb3b4a16d4f9f8f49926c4d2561"
    sha256 cellar: :any,                 arm64_sonoma:  "be655c3c5e48ae96fc96181b7d80b52c83405fb3b4a16d4f9f8f49926c4d2561"
    sha256 cellar: :any,                 sonoma:        "2074268fbd0b82871c1ad18c3c255ec716d0ef4ca17eddda4f399de5e5025507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17273dfeebf26480df6887bd5913d3170bc927ae5a7f4215e3b073f5aec9019d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e06c747c596d3647b3868653aaeeeadcb021ef4482adfac5877abbbfd92dd08"
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
