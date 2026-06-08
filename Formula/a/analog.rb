class Analog < Formula
  desc "Logfile analyzer"
  homepage "https://www.c-amie.co.uk/software/analog/"
  url "https://github.com/c-amie/analog-ce/archive/refs/tags/6.0.18.tar.gz"
  sha256 "6c5d3f05643196b64eadeccb7b5063e2508c0155ac34c1fe848f6d055c371933"
  license "GPL-2.0-only"
  head "https://github.com/c-amie/analog-ce.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "f22cbd76f12ee0e8c0d4b1796634aca86f5e3201c1803314de1e3c454b5e8c16"
    sha256 arm64_sequoia: "c00525c34d51ac0b67b85e4f9801ea066182af4d2f43fb6062275c4591a40ebb"
    sha256 arm64_sonoma:  "0346aa1c3b80936b8bcad80a898283a7094ae5a792def8892500ab07e4a8d96e"
    sha256 sonoma:        "6225d15ba873ae228f09bfb64ef1a1e4bdaecd6e3dd7d7825a2cc9b470ac4985"
    sha256 arm64_linux:   "d0050e27757f0c7a60c9a44c28fc8b57b91b0e00a1cbd4abf5e458c1deda9974"
    sha256 x86_64_linux:  "d0a8c9b27401c61853b013a89a2be2810d9b8dda0b1967270959d0838376b0e5"
  end

  depends_on "gd"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "minizip"
  depends_on "pcre2"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = [
      "CC=#{ENV.cc}",
      "CFLAGS=#{ENV.cflags}",
      %Q(DEFS='-DLANGDIR="#{pkgshare}/lang/"' -DHAVE_GD -DHAVE_ZLIB -DHAVE_BZLIB -DHAVE_PCRE),
      "LIBS=-lgd -lpng -ljpeg -lz -lbz2 -lpcre2-8 -lminizip -lm",
      "OS=#{OS.mac? ? "OSX" : "UNIX"}",
      "SUBDIRS=libgd",
      "SUBDIROBJS=libgd/gdfontf.o",
    ]
    system "make", *args

    bin.install "analog"
    pkgshare.install "examples", "how-to", "images", "lang"
    pkgshare.install "analog.cfg-sample"
    (pkgshare/"examples").install "logfile.log"
    man1.install "analog.man" => "analog.1"
  end

  test do
    output = shell_output("#{bin}/analog #{pkgshare}/examples/logfile.log")
    assert_match "(United Kingdom)", output
  end
end
