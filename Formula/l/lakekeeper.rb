class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "d7487a517e8431063f4cc6aee01637b37402ceb4db7d8a05e1f1fc86d9b6c89e"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f7271f10f1ec09aa7985c8d27f5a7d4d74aa9ef44473159c6b71904855e0f6c"
    sha256 cellar: :any,                 arm64_sequoia: "f6d924e9624c18f32dc1774e22a95edc263f45e6dbc52c8bd4dbb960026f8de1"
    sha256 cellar: :any,                 arm64_sonoma:  "ac3cf3735076050b4e5740b05d036d289f0c8d260ddf854f0c8dbb7a07edcec7"
    sha256 cellar: :any,                 sonoma:        "cecaff2bd1aa57acaaacd56a16dc197127fa1fd8815d2ebf1700cd596a004448"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e629ffb3d5e156c74a055068ccbeef84b02fbf3c99d0a3e6693f339525ae2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca3e632b99ffc2205d7dbadc9250d47b64fa2f7593317259652c81ef65c93f71"
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
