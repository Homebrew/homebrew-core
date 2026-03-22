class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-6.4.0.tgz"
  sha256 "fa243e6b199ca27b5d8b48a84f12b05435b189831b83770d2e6c0ee1fd612386"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6335a91488cc14bf7a7d94592372d30bba1ab6be2b7427e5c946a3706a2624d9"
    sha256 cellar: :any,                 arm64_sequoia: "fa1d1e71a82fcd14205a06ebcf29bd4c5be9e1ce3688a603334fd8fb2bfea020"
    sha256 cellar: :any,                 arm64_sonoma:  "fa1d1e71a82fcd14205a06ebcf29bd4c5be9e1ce3688a603334fd8fb2bfea020"
    sha256 cellar: :any,                 sonoma:        "740b00a7a0a277cc87ec701130c7600aec259d39a5a9884e8867acd61f87dcb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b021d0a68eca936903db67287359471cbf849df6381b081abae63d67dcbe95a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6adff241c67cf9f36a87c8572c3b4e065b6d5d7f8facc048e584daf0279da77b"
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
