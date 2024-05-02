class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20240102.tgz"
  sha256 "a07aea28cdcec50ef225d8c96d3944c3ef6401a913b0d78a84ddc85191ebc082"
  license "MIT"

  livecheck do
    url "https://invisible-mirror.net/archives/luit/"
    regex(/href=.*?luit[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a8d91585f05372d9846049870a8dd8740b326e76db237e5007d5af066719add"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2110ba862fe470907867a8e543d85bd2a253a0c91f68fe2e96236cb34241ea38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8903ea10c050374da17f4a0a6546fe4714ed67b6cbab8340c1381014238c76a"
    sha256 cellar: :any_skip_relocation, sonoma:         "aae1e950ee3f182fe3ff1b8c10b4f2a4ae9efd271798826387f1463b3e6aff18"
    sha256 cellar: :any_skip_relocation, ventura:        "38bbb736ecac2d362875a345f5e08cc3bb047343c373a2a7f70903a20a135901"
    sha256 cellar: :any_skip_relocation, monterey:       "8d0379d4d5cf04e4089dbc60677e7adb605bd2a782035db43dc4a4f2023a256a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cbc50eeb192059963ebd0f5fa6d0339697b328b5761c2149e448f8e33efd72e"
  end

  uses_from_macos "zlib"

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
