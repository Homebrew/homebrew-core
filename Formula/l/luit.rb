class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20250912.tgz"
  sha256 "46958060e66f35bcb8a51ba22da1c13d726d28a86c1cf520511bcf7914bef39e"
  license "MIT"

  livecheck do
    url "https://invisible-mirror.net/archives/luit/"
    regex(/href=.*?luit[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34fe7ef5c7484db64581c5f869a42e054a74996177ce74c93a2623dd9695d345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e538cd9ca308afad3716482ee10e7f623ffd90ab8f4917700c8dd102c029525"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07c6106341ee4be787dfac58149cb8bced04babe0832f4baa86eab5ef11c57f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a0508f2e99339bb372a134092c562a6f5bd83b2b5187cf303c31d77f6849c82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81f95c06decc5fba417ef18968914855efd095abbbb57a71e999fa9ff91d10b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a25f291b796b14cd3885b2007fb54efc12d256ba1e44705986bbcae7a5708c"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--without-x",
                          *std_configure_args
    system "make", "install"
  end

  test do
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"luit", "-encoding", "GBK", "echo", "foobar") do |r, _w, _pid|
      assert_match "foobar", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
