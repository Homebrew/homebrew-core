class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "0831ebb452f0dd0ddd678b0970b2ad1ead7ce2945da622997cd13f91e8cead1d"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a8924951600ecf35f81fa63fcb3e67bdf56c1bda649db6c1a14fa53dc40e131"
    sha256 cellar: :any,                 arm64_sequoia: "d11a44df64540a2286d0e8436c1ba8ba0b43d40c417a6ac174bd977521dac722"
    sha256 cellar: :any,                 arm64_sonoma:  "8177264f539c7be17c7654ed105a61faacff0a42e9aadee1a7f570b4e7ee29de"
    sha256 cellar: :any,                 sonoma:        "a0005ccc9e68c91cdc5d38526da8af9bfa6f09689123f3a4ed33be0995b6f9ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "372008f206ec3186c1a74dd2a18cc7d8485a0c13abbce406a35dfb9e14e2eb4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "478cb48065afb02a043597135ad9f687cb5e80d112b6f75d90c048368acc0a05"
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
