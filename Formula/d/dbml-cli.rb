class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-6.6.0.tgz"
  sha256 "9932feef7ac22ce2092e07626e6ed09eddb83dbdb73f840efb62647d57673faa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "badf4c4a3adb8948d056d46ade3f199d5b4d7611b027943e5d9747c4f4c24785"
    sha256 cellar: :any,                 arm64_sequoia: "8df6a52e2d391885342513005ff807e0594a285e259afffe4c9fffa3d49bc726"
    sha256 cellar: :any,                 arm64_sonoma:  "8df6a52e2d391885342513005ff807e0594a285e259afffe4c9fffa3d49bc726"
    sha256 cellar: :any,                 sonoma:        "d3c8aee84d3eb1548c25c72799de3b02e4eda6765370fc0b85921aad6deb7ad7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b8ba46036e57d7c4882d37c2aa601766aec0a349751bce97a4ba835f06246cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0673cf90f44efb2f3bcfc53ae5af924f0a9f95dbe92dcc155a36ee224d2b83df"
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
