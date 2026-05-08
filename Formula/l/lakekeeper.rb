class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://github.com/lakekeeper/lakekeeper"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "91822987cdc2df5c5028cecde783e24479062c6a661134a6fd03ce0cdaef18e7"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3afb57236609f863c0453ebd0d29e59900d845cfd6108c1edda860ec2a3976ca"
    sha256 cellar: :any,                 arm64_sequoia: "9ce2313431ff80994d12f48c34c895f1b37ebb3d3c1963a00019f2443beb9d32"
    sha256 cellar: :any,                 arm64_sonoma:  "9a6ff6d5a2dfb7b3b3bf491f513d720f754619160e1f94b0d38e66c1528631e6"
    sha256 cellar: :any,                 sonoma:        "a2ccee9c1ab490bf209cdc821dfc12327f990033be83826b0b362a094e0c4102"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fde09d5ac16db946e42735ba15351c7c1343149ef6c573fd245593443e3b96d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcdf6970236cf16fc0da8be1b554d74576de45c8c1e710b2b730e727cef88b57"
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
