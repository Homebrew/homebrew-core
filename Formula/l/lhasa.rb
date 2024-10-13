class Lhasa < Formula
  desc "LHA implementation to decompress .lzh and .lzs archives"
  homepage "https://fragglet.github.io/lhasa/"
  url "https://github.com/fragglet/lhasa/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "b0ef13e6511044ecb50483b06e630eaa7867473ec563204fe0098c00beeca4f8"
  license "ISC"
  head "https://github.com/fragglet/lhasa.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7091b3e54583531d962d3d632496d8bb7d0fb5ee9904dda89504910ba9a1cdd4"
    sha256 cellar: :any,                 arm64_sonoma:   "ba490379926bcfe5bbff0186c4a65a0a6b5c7da25bd4b7f02ed37691466b0aed"
    sha256 cellar: :any,                 arm64_ventura:  "7e94d6c751e1ca42e17bee1949f2133cb5323691ff355881e7efeeb47e74cbcb"
    sha256 cellar: :any,                 arm64_monterey: "73a6401a84fc6108220d4e621b974b233fd47e3f87a7ade8f4117322f0679939"
    sha256 cellar: :any,                 arm64_big_sur:  "30047c8030fb9cf3c874b2c688df088b4b992ade61566a8df0eb55dceff9fce3"
    sha256 cellar: :any,                 sonoma:         "7297a2924981f20648b56d4150485872c1230ffad2a84dec1ac4bcff8b589bea"
    sha256 cellar: :any,                 ventura:        "ff83cb798608b1449fade603eeea29336d2e26c9a6c15cd7685416c2fbd43862"
    sha256 cellar: :any,                 monterey:       "9263082424c274662632b1c8e1a1c321a6fca8ed859e0a137f795c3579b564e4"
    sha256 cellar: :any,                 big_sur:        "ebb0a2f44f7d1a50d22a7599e52f859d42773a181c41eb1abe52ac6a261626e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d2389e91a008a7fe1bf3cf80ea0398679d6fc783208261a60459b3851b65622"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  conflicts_with "lha", because: "both install a `lha` binary"

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    data = [
      %w[
        31002d6c68302d0400000004000000f59413532002836255050000865a060001666f6f0
        50050a4810700511400f5010000666f6f0a00
      ].join,
    ].pack("H*")

    pipe_output("#{bin}/lha x -", data)
    assert_equal "foo\n", (testpath/"foo").read
  end
end
