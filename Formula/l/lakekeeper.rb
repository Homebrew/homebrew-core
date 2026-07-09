class Lakekeeper < Formula
  desc "Apache Iceberg REST Catalog"
  homepage "https://docs.lakekeeper.io"
  url "https://github.com/lakekeeper/lakekeeper/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "dc3bae836b85405ed33991750f33e6230442274455b10ee5617be09139a525ea"
  license "Apache-2.0"
  head "https://github.com/lakekeeper/lakekeeper.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "99272e21131ddad0978f7c8c9594a596cfcae8067b73240421b963723a135bc3"
    sha256 cellar: :any, arm64_sequoia: "10333bb1e3b25b7d31256296c503dc8d440aca295872ff1bdfdf460e5beead1c"
    sha256 cellar: :any, arm64_sonoma:  "09e4e8e509c878f1d05848eef8b8c099e9227b804c3b74df0261427a495162de"
    sha256 cellar: :any, sonoma:        "c84f9e29f396a6bf6c9e64dfe1dccc512f9923c92204f5bddc7ad001ea1a755e"
    sha256 cellar: :any, arm64_linux:   "4b9ddf246d69cd0b4c7c1dfa8a705171c93509f3d0fc8f11598b9a0b85cbe9a7"
    sha256 cellar: :any, x86_64_linux:  "37c7c9053f263978971e80989ffff334b474c3ac8d9c73d514460f50621a66e3"
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
