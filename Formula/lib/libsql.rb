class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https://turso.tech/libsql"
  url "https://github.com/tursodatabase/libsql/releases/download/libsql-server-v0.24.2/source.tar.gz"
  sha256 "a6557e23f875c832a9c07c78cfb25887f6d2e3d48441eb6414a9c7a224ea6cce"
  license "MIT"
  head "https://github.com/tursodatabase/libsql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^libsql-server-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "806806643c290f2a92170fd0d7fb8c6dc023bb01cf25cb1386f70c731d5999f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3bea8027d4c55850fe1d1161c478e1303fedc8ed213ed2f3c3cbb7822f527d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d46eb1b8d7b618f92330b6034426654a037c0634c241aacf90318eff9865eaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "a373b7f0162032591f3a4e10d9d023fa34a84df061d853120a5b72d1eb992e8e"
    sha256 cellar: :any_skip_relocation, ventura:        "a4476a0a740fab17dd90bbfc59cd13a55ab901ea2a732cff2a0b1d0d5a2050ce"
    sha256 cellar: :any_skip_relocation, monterey:       "52cc4ea3fc0c8995937d84bdcaf30430400e5b66156c7468bd66575bf5dda856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5fd2a5ae01c96903a406c193d6b31ba6bdb2ce87b641fc4303ac13c58dc0c57"
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
