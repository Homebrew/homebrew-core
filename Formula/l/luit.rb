class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20260907.tgz"
  sha256 "97bd13da3e3aa59785d64504d37389612a327953bb7581508c5fea5182f9f561"
  license "MIT"

  livecheck do
    url "https://invisible-mirror.net/archives/luit/"
    regex(/href=.*?luit[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f5b123ce7d5469c83a46381fcaee6ccc283e413b81a584c02f8c099c7e85d64e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d7941cd87b5fdf5fb9efbcc22001b52e2a8c294157a131aaab4b3d99a461694b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6e4a8e69c07983ddefb0b6cafcaf7a94463b5c3e537797b6f640286e1ec959ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5c4e8169c28ded8c2a9daae40626a60981a541eef3b9859f78ca1f025f7866d0"
    sha256 cellar: :any,                 arm64_linux:       "11de53150f0de9f72960c0edefe459553f771da9aa91ed02b1f47ac6da087749"
    sha256 cellar: :any,                 x86_64_linux:      "d8d4269eb5f86e5b006805613dcf7aa8b52cad10f0e4adc0b547ce6d95c550b4"
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
