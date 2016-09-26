class Ncp < Formula
  desc "File copy tool for LANs"
  homepage "https://www.fefe.de/ncp/"
  url "https://dl.fefe.de/ncp-1.2.4.tar.bz2"
  sha256 "6cfa72edd5f7717bf7a4a93ccc74c4abd89892360e2e0bb095a73c24b9359b88"
  head ":pserver:cvs:@cvs.fefe.de:/cvs", :using => :cvs

  bottle do
    cellar :any_skip_relocation
    sha256 "29980e597d19c6dc4f9f700334a0b5f8874a2e2f3b65d5c934994c15c6e92a27" => :sierra
    sha256 "edc952c838f359516da24ae55930d1461f057703dcacbe14ce44bde3300b24e2" => :el_capitan
    sha256 "6b6bcdcb90f1ca2b9c06d928d71900ef7b88a2bbc6e0f522be2af863bf99c542" => :yosemite
    sha256 "12957fec74020f5b58975f575a1c812f9c0eec5de640d98404f2bd1429fb0b00" => :mavericks
  end

  depends_on "libowfat"

  # fixes man and libowfat paths and "strip" command in Makefile
  patch do
    url "https://gist.githubusercontent.com/plumbojumbo/9331146/raw/560e46a688ac9493ffbc1464e59cc062c0940532/GNUmakefile.diff"
    sha256 "b269c3a024583918d2279324660f467060f0c2adb57db31c19c05f7bbd958b19"
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "LIBOWFAT_PREFIX=#{Formula["libowfat"].opt_prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    ping = "Hello, brew!\n"
    pong = ""
    IO.popen("#{bin}/npush -b 2>/dev/null", "r+") do |push|
      push.puts ping
      push.close_write
      IO.popen("#{bin}/npoll 127.0.0.1 2>/dev/null", "r") do |poll|
        pong = poll.gets
      end
    end
    assert_equal ping, pong
  end
end
