class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "f04cf82c118acbaec8d644f536b242572627d10962c7ba6f3bfbe468dfe91853"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2fddca859107d20ac6a6e7cdc78ba6ef4ec5596556286e75f7b32677651fd6a6"
    sha256 cellar: :any,                 arm64_sequoia: "42dfaad135b6754c479d21bf7866c2410c0ae5449eb80e3488ec1639aadec7f6"
    sha256 cellar: :any,                 arm64_sonoma:  "9d43c8105e313b241ff749fa4d2bf62559eada33e50541b26a6f135a44647d44"
    sha256 cellar: :any,                 sonoma:        "18271d3c9443f5ba2df2a130d4af05fde333ff7a11196976db21aee9812e0da9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6aae2741f6c37569e7b474f17b1ae83631bac51767421299753926e238c2167a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3639a4245fa4e7e454d1ab10e825e7c12a31f261115a710264f48883446d1f40"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/lakekeeper-bin")
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test", "-o", "-E UTF-8"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      ENV["LAKEKEEPER__PG_DATABASE_URL_WRITE"] = "postgres://localhost:#{port}/postgres"
      output = shell_output("#{bin}/lakekeeper migrate")
      assert_match "Database migration complete", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
