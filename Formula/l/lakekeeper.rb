class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "00c3fd4a22c7427805eea96a322168253ca55f6086e81ad6a0d04554b74b69c3"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a29657c2e8cf86736a47a1d81f2fb1f8d3e4c66bcf8523bd71970f5368aae810"
    sha256 cellar: :any,                 arm64_sequoia: "1d7ba6534d0539fd25eb9081a33ea3646f7f1579ba2eae43b3c0442c64d01345"
    sha256 cellar: :any,                 arm64_sonoma:  "04dd036525bf2972a9479129e6f9f4a91bf2bbab05a009f74cce5bc6b19da0a8"
    sha256 cellar: :any,                 sonoma:        "63e2795f77e080d5fa64be57899f533866714a8b9b48ee1f34021cf4c8e16b40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2125b8f42d464bd17c05e616326599b47cf83416cf592993f881cef87299d21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6235743c9b0ea5c4154905ba4837f0ccc5ca906d074d43f063c3e6156df27e5b"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@3"

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
