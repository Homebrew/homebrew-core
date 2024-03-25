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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4380b03f3328290017a57df263bff764786c8f7cefa1d812b5d8f079f2a7bbdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d00ec7d093b685e493f93166fadc50af0e6dfe5d30ffcba4fa73a53ba28f8f4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2335f4d2fb46c43be099f883a7e46335f473203a7d21bfa8de30768e87dfa43b"
    sha256 cellar: :any_skip_relocation, sonoma:         "04fe8257c6bfcf2568f6a036c1b8177e7e58eb050480fbdd3338394ae1385596"
    sha256 cellar: :any_skip_relocation, ventura:        "82d7549e58e88172d9a624994bf034f0a3cce304ad58881b10549824c1761ead"
    sha256 cellar: :any_skip_relocation, monterey:       "f8c978ece8c9cc0695f608443be25f84b9ab7cee5a5babd9213bd58a7d96fd93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5994296a208f5f4f740e95036f17f02d9e3bc66b515c74f63c9ae13658aa4199"
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
