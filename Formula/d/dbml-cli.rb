class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-7.1.2.tgz"
  sha256 "329a42a25090700b8850ffd5869e7127e4f5ba1b471fb887ea157b989bbc3291"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "274422451c211366c825e57d63307b1d87ca0e06ee81f543ea90be38eef59f65"
    sha256 cellar: :any,                 arm64_sequoia: "ffcbd707d7d2a5605975c01924cb18f60a6b11162756642ffe5308b136bccb01"
    sha256 cellar: :any,                 arm64_sonoma:  "ffcbd707d7d2a5605975c01924cb18f60a6b11162756642ffe5308b136bccb01"
    sha256 cellar: :any,                 sonoma:        "71faa9c04e8cd0dcd4af418c829c9d150b9ca3e188618ca265a5e178ca2dfe43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cb52fdaba1101d13238e5d5516d4d0521432d2ebeec2b5bbbfd8c8a6f93521c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee84bb6f0cecb549b21195e9997cf981dc1fb9213de9dd8d66583ba7b173099b"
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
