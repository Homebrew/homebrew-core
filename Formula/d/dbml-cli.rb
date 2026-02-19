class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-6.3.0.tgz"
  sha256 "540431eda1c180f47d17e8350c7435d9d1103f91e6f1463e0974b31fab85a9d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "628cc53c0e02e04837f08f4307e018eb682313208e5d138fa9abfdcd7384542a"
    sha256 cellar: :any,                 arm64_sequoia: "71f6d01c605f9e4a6b42fd081b6de96f7e134a608bbe6fe0493d498874b20f2e"
    sha256 cellar: :any,                 arm64_sonoma:  "71f6d01c605f9e4a6b42fd081b6de96f7e134a608bbe6fe0493d498874b20f2e"
    sha256 cellar: :any,                 sonoma:        "f8ac0d4db34d083ca16d22a45d22743581a5c3ba946586e3f68a3f7f67c77723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6058ad3ced0d07cad6ef9f53ddc63072351bed21a5fde6150fb2d276606db861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c78b0e9d7dc1963453548deb35d2af34fa5234340d8edbcef4899c5365c3d77d"
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
