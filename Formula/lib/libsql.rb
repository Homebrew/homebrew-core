class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https://turso.tech/libsql"
  url "https://github.com/tursodatabase/libsql/releases/download/libsql-server-v0.24.14/source.tar.gz"
  sha256 "e35a7f77c81724a232adb92be57a1f18bb859e4d2a8534793df0bda06314bf03"
  license "MIT"
  head "https://github.com/tursodatabase/libsql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^libsql-server-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f97518439c92ed4eb334e233c81c45d3ef28503095b8ab05e7e5ca08a6783fbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4beac2b2a3ff69d406b015a7490bbddbef0f14527d24ee4a7bc3a4f95d33270b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa735c88ee064fbafe689c2f7c95f6775b02280ea7d6e9ed59f16c36a990171e"
    sha256 cellar: :any_skip_relocation, sonoma:         "af69310802f5948cbfb95543c402a33db760a6374c8baed3619d39a1ede1a2fd"
    sha256 cellar: :any_skip_relocation, ventura:        "b896fb9096f4a4d81127c6d57a70f42ac888eddcae5f0ae17255dd237bc36ba9"
    sha256 cellar: :any_skip_relocation, monterey:       "84d9bdbea8d0a28a0318e9d5ec81e5b3e06c013db5e57c935d6a102deda390fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "796c6a7349d5090f685c3bc64c8b8efc26c43b518b683f06b33be1e4a95dfbc2"
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
