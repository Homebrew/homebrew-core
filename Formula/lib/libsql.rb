class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https://turso.tech/libsql"
  url "https://github.com/tursodatabase/libsql/releases/download/libsql-server-v0.24.18/source.tar.gz"
  sha256 "f35775ffb30d39a4ed91ee4d813973cae00d3b960c100989aa4ff78204beff1e"
  license "MIT"
  head "https://github.com/tursodatabase/libsql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^libsql-server-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "061c2d08fe90a581d09c33ab33c9ea9a1dbd43f6afead1db01e7612f7eaa3988"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c117e5ff52d02f01225eb114bb47862db84f1a441088c00fc64001fb61606f45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f665cd874f66b69ada5648960a8cd25020e7e9fe340923192386c749de66298e"
    sha256 cellar: :any_skip_relocation, sonoma:         "41b76f5b1dcdf90621294b1c0020ea9fa11b079de6d9ebb929e1ed8cb7a447d5"
    sha256 cellar: :any_skip_relocation, ventura:        "a0fab4c1c6c58105d449f21a4adc9fc68d8607953bb946f926e5ed300d2b0f77"
    sha256 cellar: :any_skip_relocation, monterey:       "ae621076f28f11b566abc4bde675aadee9fde4a54d7765a4fae6e43f4536e736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a856e18204174491ac5fc5dba0cc2576b173dc7b4c0aca6a4f6613ffdb78791b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "libsql-server")
  end

  test do
    pid = fork { exec "#{bin}/sqld" }
    sleep 2
    assert_predicate testpath/"data.sqld", :exist?

    assert_match version.to_s, shell_output("#{bin}/sqld --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
