class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "557b06f08a045a7332d32b678fe6385797781310fd675a179552044d45fd8aec"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "026006e4c32adcb2edc7e6339a8a9efc5fe3b32ff9d8fbcaca8efabf5b5ea865"
    sha256 cellar: :any,                 arm64_sequoia: "35ca6283b9a42c121051668873be6c920245a91bbbe0b656181546437419dcaf"
    sha256 cellar: :any,                 arm64_sonoma:  "3a997ea710c24d850b061e6e135e51adb7ff032b9dbde6348c4d95d64cabc77c"
    sha256 cellar: :any,                 sonoma:        "0a2cf991acfe204dba8e759b8ba6b5a89f0a3c38ad595918d5b732100c74b0a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f711c0f32f161915f9b1de757773399389236c33d7e22dfd41ddd8d46fcfc388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a17f0d6f7842f1189344ab90f454a1843d5c9c1af7f2edc43be92991bd7633b"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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
