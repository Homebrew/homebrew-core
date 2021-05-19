class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.2.2.tar.gz"
  sha256 "151e5ce32403f65892b0a15df04310ee4d115e12da9d38a7289f13f20e753d92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "77960cc7206e2279204fd92e30b466aee5d5efb275726a882951a6209bfaf019"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c125bbc495e7429b58a9dd52c3f2c03b64f46d4f4193f7bc63c4ab60059a22b"
    sha256 cellar: :any_skip_relocation, catalina:      "463fcbc3b50a8ca76dffcf3d706637b8a613ec121421038fba5a249dc90c39bb"
    sha256 cellar: :any_skip_relocation, mojave:        "1851ab7697763b69a1dc9af241fa29877c42940634ee881b99feb0bea10ab297"
  end

  uses_from_macos "curl"

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "mandir=#{man}"
  end

  test do
    output = shell_output("#{bin}/hblock -H none -F none -S none -A none -D none -qO-")
    assert_match "Blocked domains:", output
  end
end
