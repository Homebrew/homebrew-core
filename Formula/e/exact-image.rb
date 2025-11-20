class ExactImage < Formula
  desc "Image processing library"
  homepage "https://exactcode.com/opensource/exactimage/"
  url "https://dl.exactcode.de/oss/exact-image/exact-image-1.2.1.tar.bz2"
  sha256 "7843cf35db40f3a2caed3d0b11256e226ef16169244ca2dc1c89af86ac8a148a"
  license "GPL-2.0-only"

  livecheck do
    url "https://dl.exactcode.de/oss/exact-image/"
    regex(/href=.*?exact-image[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b37a3a8d7dad43283a963946344b7851d83197ab6c582db6c73ad3609e38b97"
    sha256 cellar: :any,                 arm64_sequoia: "f44f495419aa32f25be9e14a76466def5388eb6535e8f8a9b0755a87431342cc"
    sha256 cellar: :any,                 arm64_sonoma:  "f206295b88ae90ba83c514706654efbe65fc2667e42050926a82a9570a54eeba"
    sha256 cellar: :any,                 arm64_ventura: "0482d18c47021b7fa3f907971a2d90838d0f34af8b5d69bc1835370fc291f34f"
    sha256 cellar: :any,                 sonoma:        "8a06515f2eab356cc7d5aeae79ad6b295f26dc4dc1dfd488e1182195a8621dd1"
    sha256 cellar: :any,                 ventura:       "1fe4cac55b6ff73ec09fc4f326047cbd01398d6787d2a4b35aa0b5e1d3429757"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3412d6da12249b60dac2138039b7a4adb36a81f91dda797cffa77789e6244a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bef9ef7ca1825d02d60715181c08c112cbf1d14eb9c891325dafd6e001ff602"
  end

  depends_on "pkgconf" => :build
  depends_on "libagg"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  def install
    ENV.cxx11
    # Workaround to fix build on Linux
    inreplace "Makefile", /^CFLAGS := /, "\\0-fpermissive " if OS.linux?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"bardecode"
  end
end
