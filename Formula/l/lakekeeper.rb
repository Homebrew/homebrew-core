class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://docs.lakekeeper.io"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "e7f9ddb3a41a836f71652ab5c847b79cb4d8e463b871b1b94153bf37a011f1d3"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a27d73b362edf4044b399174955706d24694744c43bd8dc8e0ec1051f2123b91"
    sha256 cellar: :any, arm64_tahoe:       "873d1bcb83e1349cd9077f345d928da6bfe456342d709e83839c5c09cfc5016e"
    sha256 cellar: :any, arm64_sequoia:     "8886491bb0217902af839a86e0a8e39e8a4b4841705e91a99bd25534b08f3549"
    sha256 cellar: :any, arm64_linux:       "95aa1f5f75cc2502b7113c26f7382a37ffb82be4351029e511cb163c4f17125a"
    sha256 cellar: :any, x86_64_linux:      "191a30fd10aaa13689f293d392fd933349d2b8605e3ff945dd8cb8d09364af1f"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@4"

  uses_from_macos "llvm" => :build # for libclang

  allow_network_access! :test

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl)

    system "cargo", "install", *std_cargo_args(path: "crates/lakekeeper-bin")
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = deps.map(&:name).find { |d| d.match?(/^postgresql(@\d+(\.\d+)*)?$/) }
    pg_ctl = formula_opt_bin(postgresql)/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test", "-o", "-E UTF-8 -U postgres"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      ENV["LAKEKEEPER__PG_DATABASE_URL_WRITE"] = "postgres://postgres@localhost:#{port}/postgres"
      output = shell_output("#{bin}/lakekeeper migrate")
      assert_match "Database migration complete", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
