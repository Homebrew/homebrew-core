class Analog < Formula
  desc "Logfile analyzer"
  homepage "https://www.c-amie.co.uk/software/analog/"
  url "https://github.com/c-amie/analog-ce/archive/refs/tags/6.0.17.tar.gz"
  sha256 "0e5794c2eaa5826dc014916e413e90eb2714a646ff8d6ec026437182d789b117"
  head "https://github.com/c-amie/analog-ce.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "b042b7f5fcfd04f54e5af93246fbb78b177cf451bffef7846d0dced79033d140"
    sha256 arm64_monterey: "a74246c3d600b97bda4fd849c0caf64411b31e16655556af926bb5d88f44cfe8"
    sha256 arm64_big_sur:  "beb7f7127ad0f454f40cccaa66f4077794ebd5934f05e9c840597b45334cf481"
    sha256 ventura:        "5cb38b8b847b525e7175d5e2521cfcd1917cf3093944c14a3ee37281979fe3c6"
    sha256 monterey:       "287cc493b5904e13b3ef413c0ef77adcab7ffa3594de77a9faea8191b3778efb"
    sha256 big_sur:        "50fa1aeee5b2e43b579d4b0186f77e8686e9db57c8e9d7c7a0c598bba7c4693d"
    sha256 catalina:       "e0cb5d41e7a8d9d36e056d3f32cd2c0250541b9d2b778fca7748a58d3be17778"
    sha256 x86_64_linux:   "7ed66e29509cf19e47fc7b4b0b063aa2fdc0bd7a04ec9684cbca21f9bbdb9829"
  end

  depends_on "gd"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "pcre"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = [
      "CC=#{ENV.cc}",
      "CFLAGS=#{ENV.cflags}",
      %Q(DEFS='-DLANGDIR="#{pkgshare}/lang/"' -DHAVE_GD -DHAVE_ZLIB -DHAVE_BZLIB -DHAVE_PCRE),
      "LIBS=-lgd -lpng -ljpeg -lz -lbz2 -lpcre -lm",
      "OS=#{OS.mac? ? "OSX" : "UNIX"}",
    ]
    system "make", *args

    bin.install "analog"
    pkgshare.install "examples", "how-to", "images", "lang"
    pkgshare.install "analog.cfg-sample"
    (pkgshare/"examples").install "logfile.log"
    man1.install "analog.man" => "analog.1"
  end

  test do
    output = pipe_output("#{bin}/analog #{pkgshare}/examples/logfile.log")
    assert_match "(United Kingdom)", output
  end
end
