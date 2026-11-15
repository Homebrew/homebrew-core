class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://docs.lakekeeper.io"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "8d8e0bd868aa718d1a0e10d1d2ce6ab6dde363ecaf781ab25c512e67ce895e67"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "670d579105e528ae2a378100d099cfa6eb1bdffd621511f466c9a5df8a8230cc"
    sha256 cellar: :any, arm64_tahoe:       "42a6633dc8a60f166b2d6766a1cd0787092a92bb0b567c2fc682ac91d34d5460"
    sha256 cellar: :any, arm64_sequoia:     "9c8e736fde43dad0f93174e5a0f2024e3cd93d2b3608c7ac962c485195ffb955"
    sha256 cellar: :any, arm64_linux:       "f5f90265e4afefab1d4035df18cef765f724ab9651619d459b0aad40f2d3a36e"
    sha256 cellar: :any, x86_64_linux:      "536c222737d9a45201215948e15dcd5306e34b132fa56a373fbb2d8e5027f268"
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
