class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://docs.lakekeeper.io"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "6873011cef5295f2a6f04331f0e94c55f5c720044d1c8f23900fbfa6d940eb66"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "81c214fcec4cd3c8509caa108806a7d0717c1477981d03a03804342c2bd83f40"
    sha256 cellar: :any, arm64_tahoe:       "f8364a0ff01d7a810f58817cb95519d8aaf43a01368bc4b39be9bd28abc7c723"
    sha256 cellar: :any, arm64_sequoia:     "9ce7dcdac3c4f77b8eec833022b4d4f416c19db00f6ad18685d8d395d904a743"
    sha256 cellar: :any, arm64_linux:       "52bb05c34448ee27e22b67e78b058f64f7d540e95d34f318f0a1288b262ad9c2"
    sha256 cellar: :any, x86_64_linux:      "98345406f0c7a22b1acf8875b13719810540fe5cb74882c434b2bf69bfe28547"
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
