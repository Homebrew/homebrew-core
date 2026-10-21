class DbmlCli < Formula
  desc "Convert DBML file to SQL and vice versa"
  homepage "https://www.dbml.org/cli/"
  url "https://registry.npmjs.org/@dbml/cli/-/cli-10.3.1.tgz"
  sha256 "108bcb99ed26344e04a2d02931a3d0caa52564de6407d3be7570dc92e6cb5c04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "f11c8653c01c1b936e9304ca671f5efdfca7d49da4d1867cdec6c6009db7a4cd"
    sha256 cellar: :any,                 arm64_tahoe:       "f11c8653c01c1b936e9304ca671f5efdfca7d49da4d1867cdec6c6009db7a4cd"
    sha256 cellar: :any,                 arm64_sequoia:     "f11c8653c01c1b936e9304ca671f5efdfca7d49da4d1867cdec6c6009db7a4cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aff8683e7cb69dfc1f7136e7fbdd365e18d8d6c5d0ba7f6c496986c1c8dadfaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "339b6481969782a2110af8ea76b4de7792dd4d846bd21fa7411f3e1dd039570d"
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
