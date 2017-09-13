class Libbpg < Formula
  desc "Image format meant to improve on JPEG quality and file size"
  homepage "https://bellard.org/bpg/"
  url "https://bellard.org/bpg/libbpg-0.9.7.tar.gz"
  sha256 "05035862ff4ffca0280261871486f44e74c4af4337c931e0858483551e6efe25"
  revision 1

  bottle do
    cellar :any
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
