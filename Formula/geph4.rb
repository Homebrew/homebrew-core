class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.3.0.tar.gz"
  sha256 "2158e562a39f0e6deecf0cf4a60f17314d99cc7e185c3803ddc219c3c5d66adf"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d92f268a2301b5436b28924982ee0e37781f9fc880d550a7757bd5577731ac6"
    sha256 cellar: :any_skip_relocation, big_sur:       "712fa28c77fa9b35992353a9ded7efb9ce374d6bb334dc35bf98aae03ca8d542"
    sha256 cellar: :any_skip_relocation, catalina:      "064ce4a1604c4de65a12deadcf86e1d6e57e7c47e4c1a2de91ec540e1f87e7bb"
    sha256 cellar: :any_skip_relocation, mojave:        "c7e3be53ac8208f54632730e11a7eeb3979a86c511efe7614a7c80298ac16319"
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
