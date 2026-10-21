class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://docs.lakekeeper.io"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "0b4356fb0ff72ca580959a4685be5412d900d81e0f27cbb5b8c95cab4d50b0c9"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "53cd534d733d3c0d95585cf879835f4948361a233c0c0d7456d9917cc0f24a1f"
    sha256 cellar: :any, arm64_tahoe:       "bfb778613ecf3ca1a910e64e120ea53111f0b4ef4ee10cc76a8db5c5071616ff"
    sha256 cellar: :any, arm64_sequoia:     "338201c806e42dc94d8adb3d1fbba81f5708a38fce73fb75072309660b7f0f84"
    sha256 cellar: :any, arm64_linux:       "13cb7547ac203faf9f424c391e546fe59af95bfd9bb5847a3f3fed324ce4dc43"
    sha256 cellar: :any, x86_64_linux:      "609b5e626de471cf0bca023e83b585c56faed46e0ad50532a650741e07bb7b03"
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
