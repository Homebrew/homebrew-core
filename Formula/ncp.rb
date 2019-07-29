class Ncp < Formula
  desc "File copy tool for LANs"
  homepage "https://www.fefe.de/ncp/"
  url "https://dl.fefe.de/ncp-1.2.4.tar.bz2"
  sha256 "6cfa72edd5f7717bf7a4a93ccc74c4abd89892360e2e0bb095a73c24b9359b88"
  head ":pserver:cvs:@cvs.fefe.de:/cvs", :using => :cvs

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "345fcd7aaa3fbe0352a0109c986389db0cec91b4603829b4f36998ad866e5aca" => :mojave
    sha256 "2c56e482f1608eeb3925f4db0b1ef782fb1644d2a7318e522a4a3c7ba7efcdd4" => :high_sierra
    sha256 "d261de84549f890b4a3ca4c9f9d72ec25dd5a66c77fbccf6c29577c49a3c0866" => :sierra
    sha256 "08f17ef57ee62eb3ca90c7c033fba68edc2822d93689ddabdcaa49913c98f369" => :el_capitan
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
