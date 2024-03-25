class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https://turso.tech/libsql"
  url "https://github.com/tursodatabase/libsql/releases/download/libsql-server-v0.24.4/source.tar.gz"
  sha256 "c4c1b7dcfe77b745c6d5d1e170f40daec7e008224d17a4857d094f6b6b43259d"
  license "MIT"
  head "https://github.com/tursodatabase/libsql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^libsql-server-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37da197fe5684a6d8e5583537cd19bdf86389ee495ad61d34b63c2166134f85c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdebb82d0080e8d7fdd39158b5a3534459a99f8c5a5f3441ccbd0793727392f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ea880f5431d4867a2f526daf0a33c8e6c7535c659b4228276d7735576715b1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b00576be2dd560e9ad96daa897852dae7903a597f80668302b96ef5dc0160b6b"
    sha256 cellar: :any_skip_relocation, ventura:        "9f975d2bf179bd6eb768b40421857eb4b24b6c4df995f5087bd1e369b4cf7628"
    sha256 cellar: :any_skip_relocation, monterey:       "df9c05034a8959e927db395193ae4a90471a612c43b05d0b9f839509ecbc35a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a3d8440b67861cd12e41d48ca901cb3b013cde08e577ef5df7c9baf1390b881"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "libsql-server")
  end

  test do
    pid = fork { exec "#{bin}/sqld" }
    sleep 2
    assert_predicate testpath/"data.sqld", :exist?

    output = shell_output("#{bin}/sqld dump --namespace default 2>&1")
    assert_match <<~EOS, output
      PRAGMA foreign_keys=OFF;
      BEGIN TRANSACTION;
      COMMIT;
    EOS

    assert_match version.to_s, shell_output("#{bin}/sqld --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
