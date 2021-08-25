class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.4.12.tar.gz"
  sha256 "43bde1dda387a89131f5f33a9e75a5c4bc9b410cd3e5cd34fed0d0e9f942cf27"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "14ea32e04cddf8f57948ac0713498feac1ff67a3a21444b086d310b2ac357581"
    sha256 cellar: :any_skip_relocation, big_sur:       "946cbdea16d4655265041c22d5da459a74ef2dbb96e346ff49e8ac4e29e55b8b"
    sha256 cellar: :any_skip_relocation, catalina:      "b7e920f04e407d195c7290a1ae08f3bcf043992c537a9af100f43027f45b2179"
    sha256 cellar: :any_skip_relocation, mojave:        "6bdb993a7e1affa92146f4c2fb6f6177497e3543b1323fc9a621fc8723a11828"
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
