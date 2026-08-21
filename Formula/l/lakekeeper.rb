class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://docs.lakekeeper.io"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "d42b7996343c0c86fa1c086452dc80dda96b54a4503488d0b9d283817737d060"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "977bd4ea25df024c7e0b48509473d29e1a089f1f55994ccda708462078f8adaa"
    sha256 cellar: :any, arm64_sequoia: "d57ab8f7117df5bb96121ba34a86e132a32f2d5658277d98614902b1e78f9ec0"
    sha256 cellar: :any, arm64_sonoma:  "3adac933605d3d36442f0e0c2d8da485f4ac973a319f532b8dc9842938edbcae"
    sha256 cellar: :any, sonoma:        "133b971fd6aef40c426c885761148c287aaf614615c986eee8dfd6a01ad58cc4"
    sha256 cellar: :any, arm64_linux:   "7da564ccb9f39e819e2413e1b7a30bef616024034c30c47096f4a11feb6f0e8b"
    sha256 cellar: :any, x86_64_linux:  "70a7da63209aa81db664ac6b97402cb8749b5251f4c2e7e95fae6475be5c849a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@4"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args(path: "crates/lakekeeper-bin")
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
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
