class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "4890fb0b5b6548ec7175b301b0bfe043227007c3e6e23df0695ee2894f86579d"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f420ee3280aaa5ad869c66bb98ee5cb3cb5a6bd4bf1829f1dd85bd3770d8484c"
    sha256 cellar: :any,                 arm64_sequoia: "3cac9ed4acfabad9814695dacda36c59522baeed184a6e259f031b80f350dda6"
    sha256 cellar: :any,                 arm64_sonoma:  "f721fa4ec6f581842959e950485b55bdb4bf1963708ffad84451b200bbbd2eb9"
    sha256 cellar: :any,                 sonoma:        "d85100cb2be7696b2f85952d7bf5decbae59854cf2bd3874559cdf6a29e2e7f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89a4e0d9ffa1582905b20576a87fcfe050898a5f3bd77247cb2dd32ba56a5093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9faad18dbe20a81ec0dc8bca5acc302f1290a99c30f25811f3de2158df6a9e4f"
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
