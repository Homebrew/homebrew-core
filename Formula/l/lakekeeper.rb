class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://docs.lakekeeper.io"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "0ad762505286c5fae7e590fe6c21983e5c77fb6afeae615e7545137df9c3c6d4"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "450f595b56689aee7e7802243b6e36ea9901500433400af2ed7d72fd19ec2ef6"
    sha256 cellar: :any, arm64_sequoia: "1b501b0b516cc0c29a44ffcfc5cfcbd12dcb51169dcd068e554c93a9734068d7"
    sha256 cellar: :any, arm64_sonoma:  "89fa374b3a94c07e60a6765dfa627f93bd9e98cf2f9bb041a852f1c17e84e8d9"
    sha256 cellar: :any, sonoma:        "d4d56fce4bdf54014d042ef495d9caad3845d4ac8661dd924d6c9f2d51d8a7d1"
    sha256 cellar: :any, arm64_linux:   "1e136fbcf15836c099e618e5c43aa789b7aa35537b50344a1901120daa4a127a"
    sha256 cellar: :any, x86_64_linux:  "9405b94e255f5f310f380b73a967ce9f2511821941ba888f8a09749e2364ba84"
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
