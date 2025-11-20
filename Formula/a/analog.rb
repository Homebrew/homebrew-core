class Analog < Formula
  desc "Logfile analyzer"
  homepage "https://www.c-amie.co.uk/software/analog/"
  url "https://github.com/c-amie/analog-ce/archive/refs/tags/6.0.18.tar.gz"
  sha256 "6c5d3f05643196b64eadeccb7b5063e2508c0155ac34c1fe848f6d055c371933"
  license "GPL-2.0-only"
  head "https://github.com/c-amie/analog-ce.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "f7dcb27fbb927e223eb5de35e0121ed04978d431cbda451bc90d514db6f91898"
    sha256 arm64_sequoia: "cf6b6b5922287fd9aad880021dbc161e361b3e1a485ae29ebba5a205085c9bd1"
    sha256 arm64_sonoma:  "566c70a3d0443d7072dd51cacc8d0717fbc0d39d34c7a5ea2283b85238e565b5"
    sha256 arm64_ventura: "6165d65fc23d23b5abf3ee30b59ede9b9626de03259e6ce24779adb72870925e"
    sha256 sonoma:        "67ef4efa366ab045c74c946acfee46f118d1053b90f477493476e814a4247c30"
    sha256 ventura:       "7b02e3af7264089c6f6c9fbf9e7f5568be220104ca01bc17a640d4e4979b2dc2"
    sha256 arm64_linux:   "d24b9f6178f2c5b1f903e5c5416a8ae63c40906c5e4761eeaa144cbf21d26072"
    sha256 x86_64_linux:  "f81a6b3348847b5dbbcfad4242a43d9a98266c7cbc037a22656a610a3ffa2104"
  end

  depends_on "gd"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "minizip"
  depends_on "pcre2"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
