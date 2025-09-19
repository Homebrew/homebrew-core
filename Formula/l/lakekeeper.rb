class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "073bca784b86fb7b151ddf7bb6b285000b5165b25371042637e82ee649b59043"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "06277dc5f81ed3b1a1394219e9c7910b4587c903d794ab268d5d5b654adf7fc1"
    sha256 cellar: :any,                 arm64_sequoia: "10e47272fda03d38741856e67480fa4747bf0709aceb2d2b267c4c26d415f72c"
    sha256 cellar: :any,                 arm64_sonoma:  "aab049853f2720cac3ca70dd1e6c7d5ea97e132f1633e6815f8793c81e60dc38"
    sha256 cellar: :any,                 arm64_ventura: "38ec74a03007c6fb07552dd59b9f89e315f249e50b0b2af2b19390f5ce79d1b3"
    sha256 cellar: :any,                 sonoma:        "dc333353ee7353098d9058d30d279c8d65d488a410dd1a3d212046a8b5f9f4a7"
    sha256 cellar: :any,                 ventura:       "d90784357e2456beb936d040e6020ee93c2b43ff74838bd0f7838aff103b60ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba21307721e0cc0fa049e0bea933395991f9b3a5967395ad61581cc512934649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f76fa7aec414959458efbb2d9ad527f812d9488f00b93389ccf1cbfa0a24ba5"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "postgresql@17" => :test
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/lakekeeper-bin")
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@17"]
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
