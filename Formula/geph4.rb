class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.4.12.tar.gz"
  sha256 "43bde1dda387a89131f5f33a9e75a5c4bc9b410cd3e5cd34fed0d0e9f942cf27"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b23439012e62c7726234caccd151872ea7869b4a1c2176738cfeafb148484a0d"
    sha256 cellar: :any_skip_relocation, big_sur:       "232e24d70b4e619d92a3711b0d8722adefe92fc898f47c1db02d76607553b365"
    sha256 cellar: :any_skip_relocation, catalina:      "0c6b525e75b72d9721f5830eea0283097222f54896cfe8a490020826afcf6e66"
    sha256 cellar: :any_skip_relocation, mojave:        "554f9cb02bdb95461ba13e641beaa18253cd79fdf1720b993ae9315743e7197d"
  end

  depends_on "rust" => :build

  def install
    File.delete("Cross.toml")
    remove_dir(".cargo")
    Dir.chdir "geph4-client"
    system "cargo", "install", "--bin", "geph4-client", *std_cargo_args
  end

  test do
    assert_equal "{\"error\":\"wrong password\"}",
     shell_output("#{bin}/geph4-client sync --username 'test' --password 'test' --credential-cache ~/test.db")
       .lines.last.strip
  end
end
