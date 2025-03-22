class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20240910.tgz"
  sha256 "a15d7fcbfc25ae1453d61aec23ff6ba04145d6e7b7b3b0071eb5cfda3a3a49d5"
  license "MIT"

  livecheck do
    url "https://invisible-mirror.net/archives/luit/"
    regex(/href=.*?luit[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c2cf2f64b1e6e8c0f651be99800c33bb43bce794d6d794620bccdddf8abff46d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4773607117055df4f056d073763f69474bf9711d0e99707b878fb612968c4f88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "292d7861ad2364235c5767308dcb30756732a95d83f73602c47da7e48199db86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c936932f270a6ab28c19d92d40fa77e24878ae706b98faf4935439c08f6e108c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0592ebe8ed9e681825751321c0e3ab8673d25ac47e22c4ea6b9cb1bb792f237"
    sha256 cellar: :any_skip_relocation, ventura:        "25a7cc8a54ca686cc97a010ac512a1130ef5b6fc4f8c7701436b6d0de96dc8e5"
    sha256 cellar: :any_skip_relocation, monterey:       "98ee90ca679b3b451df2dd122cc1846f1ca41af22ffd56bad142eb9944feb733"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "16768af2646e4b9ea7a1841eaf353ebb1ea82d6bd752e18d557484ab9503b4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "731e2b4330c98ecd23d1cb1220bd123c5561a91e8e43a0c8f7ac42ac68e14896"
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
