class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20210218.tgz"
  sha256 "f3c7cfea61f4175b087fd4200e8e43d2d4b87575ed265403f9d67850ea1740e6"
  license "MIT"

  livecheck do
    url "https://invisible-mirror.net/archives/luit/"
    regex(/href=.*?luit[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8489ef39ec862af821594bbbb5fcab32be3e800f7d61ac820b70ae83c2b119bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59a2f49d9d55f6895dc9efe0f120f2eb1bb85fd2913111a6f1796ce10aa01d19"
    sha256 cellar: :any_skip_relocation, monterey:       "2ec93ad0daf0de32667561cdbca6e22530e29c24a2421082f81c6f6b10d8eed4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cff5018af9138fc6c82bea31e1c5b24c2cb9ea58ad1ccd2a94f378c114bd9c68"
    sha256 cellar: :any_skip_relocation, catalina:       "56302c6bc88e802dfb5a6341aa30873966d8b6c97c7f676ac9dc9491e97ed941"
    sha256 cellar: :any_skip_relocation, mojave:         "a28524fc17134d511703c000276d61ca2741cb5f9e4f4e36ee55e1300b7595a9"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make", "install"
  end

  test do
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"luit", "-encoding", "GBK", "echo", "foobar") do |r, _w, _pid|
      assert_match "foobar", r.read
    end
  end
end
