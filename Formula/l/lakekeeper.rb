class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "a1c12adfc461102ce34b6d88b516aacb4a842bc41ddde01a861d7b6f112b7d7d"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "760e4c224912f636d3156146ab987bfec8f45a487add2f3c70c170e7694f47e8"
    sha256 cellar: :any,                 arm64_sequoia: "00ff291d91d4773c2e28274ac20e5f692cfca16131b755b2937033aca644ee57"
    sha256 cellar: :any,                 arm64_sonoma:  "33528c210128f62e72c5520b2d5c3a2879a2f1e0590c6a32ffaa00f061a18f3b"
    sha256 cellar: :any,                 sonoma:        "5b6d15ade6da51e01f18a6423b4b4eef8fe20a0217992f77597f1b7325906cc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "798e790701bc8e65e9df67c6ce8e3dcefbc853fb324344986c86398418750d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9937dc3f9f972eb561f1a42d90a366c9cca264829e1f4ddef26d0d5a1478010"
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
