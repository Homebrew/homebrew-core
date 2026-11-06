class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://docs.lakekeeper.io"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "e7f9ddb3a41a836f71652ab5c847b79cb4d8e463b871b1b94153bf37a011f1d3"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a05c1a5fc3f70d5cdc483b6e75b76b5a729a9dea680953772220039cde8f53bd"
    sha256 cellar: :any, arm64_tahoe:       "d50253691a0d6af1e6f59a621729364d83d1bac56489a3ee32091a5bed26b78f"
    sha256 cellar: :any, arm64_sequoia:     "f87d8beb9dfb3d7242c887d71dc7413ff6bc07d8d9957dbbdf2b2c046327c58f"
    sha256 cellar: :any, arm64_linux:       "d4ae7eda3115605b4bb65653f930068f4cbe8d8901200b72ecfec891161e568b"
    sha256 cellar: :any, x86_64_linux:      "e111063c41aa8dcca39a67a2c3516ee50ed1853278b484887d4c5471c5c8d604"
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
