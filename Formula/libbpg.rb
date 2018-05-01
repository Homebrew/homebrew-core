class Libbpg < Formula
  desc "Image format meant to improve on JPEG quality and file size"
  homepage "https://bellard.org/bpg/"
  url "https://bellard.org/bpg/libbpg-0.9.8.tar.gz"
  sha256 "c0788e23bdf1a7d36cb4424ccb2fae4c7789ac94949563c4ad0e2569d3bf0095"

  bottle do
    cellar :any
    sha256 "16282d6e4cf9e52744b8e7cbc9c0f7e154a306481ffae05f5419dde6e652a24d" => :high_sierra
    sha256 "d8f4592c6b4f08a707ec68d6e3632c9cb4fee0a04d5ef5a7b802cbca1fa3db2b" => :sierra
    sha256 "9f4167b1c41e72ae86ec7df56520b11f42f38216c49152698fb888aae30d106d" => :el_capitan
    sha256 "77a695f988e9da935a326964aa8f833ec6a9370e22895d107e6d05b750ee4b6f" => :yosemite
  end

  option "with-jctvc", "Enable built-in JCTVC encoder - Mono threaded, slower but produce smaller file"
  option "without-x265", "Disable built-in x265 encoder - Multi threaded, faster but produce bigger file"

  depends_on "cmake" => :build
  depends_on "yasm" => :build if build.with? "x265"
  depends_on "libpng"
  depends_on "jpeg"

  def install
    bin.mkpath

    args = []
    args << "USE_JCTVC=y" if build.with? "jctvc"
    args << "USE_X265=" if build.without? "x265"

    system "make", "install", "prefix=#{prefix}", "CONFIG_APPLE=y", *args

    pkgshare.install Dir["html/bpgdec*.js"]
  end

  test do
    system "#{bin}/bpgenc", test_fixtures("test.png")
  end
end
