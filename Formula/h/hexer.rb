class Hexer < Formula
  desc "Hex editor for the terminal with vi-like interface"
  homepage "https://devel.ringlet.net/editors/hexer/"
  url "https://devel.ringlet.net/files/editors/hexer/hexer-1.0.6.tar.gz"
  sha256 "fff00fbb0eb0eee959c08455861916ea672462d9bcc5580207eb41123e188129"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?hexer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bd7a6cbea17a087bc8c9f58fbd4dcc595ea3c1f65760a6c1f7c34d9e4c2c7b1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5bd5b3ffa68b3200ee5cdda6afa4ed5982760598c759bebc1497404abf170b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78608e7de426f8d081f22e85878d8d0a42388246d79ad773431164f65b05e867"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71e185121e08ddab73b7f5071eee7420fbb87b159a0a0cfb8d99202e86a407cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "870e4eee439fd986b917b966c67b59965a643e71b4cc33ea9b28236ee248a170"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c84fa4cf1ada9f83e915bfb80384901799d678d5a97eff7e244534bdbb67f48"
    sha256 cellar: :any_skip_relocation, ventura:        "019c5a1806bd439ff70d9efee99d3202385da58529bb5970c24f8e435c9b660f"
    sha256 cellar: :any_skip_relocation, monterey:       "88fc357578acfb6e88b9b1e5c1a07bae269a7d3811269fcd6d14ec86c5efc04d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9f70c4af623ee7ffbc9da870f2b07b527b27ccab166243febbd206f4a78eb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d2555b996ecdfe5178d26c9b7279c882fbdbff1551b8f71b6d232338ccf2c74"
  end

  uses_from_macos "expect" => :test
  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man1}"
  end

  test do
    script = (testpath/"script.exp")
    script.write <<~EOS
      #!/usr/bin/expect -f
      set timeout 10
      spawn hexer
      send -- ":q\n"
      expect eof
    EOS
    script.chmod 0700
    system "expect", "-f", "script.exp"
  end
end
