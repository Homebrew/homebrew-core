class LibimobiledeviceGlue < Formula
  desc "Library with common system API code for libimobiledevice projects"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libimobiledevice-glue/releases/download/1.3.3/libimobiledevice-glue-1.3.3.tar.bz2"
  sha256 "920ce01382a32695f49b23292b4979a03f0afd16c58e8755d8b7f41804acc1a9"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/libimobiledevice/libimobiledevice-glue.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dc5369924a2c6a2a72fa0272ad2e555368d9202b5d277128ec9015ce118a4d38"
    sha256 cellar: :any, arm64_tahoe:       "771ea125dd999af5879f39529abd5faa2cb1bff83a52f87c95e842d4c0cba942"
    sha256 cellar: :any, arm64_sequoia:     "8b529b79effd76fac07f8a85e1596a3e7b6b0c18f06f07c1579b5b5c45b0110e"
    sha256 cellar: :any, arm64_linux:       "09c546bf5ba30af4019a0e43d5bdc2a4e0a8b5f027d51407be7f430c7f380819"
    sha256 cellar: :any, x86_64_linux:      "4ef415035d620334870921e36e0f6d4dd973af3507c9d20d464b3648647f008a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libplist"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "libimobiledevice-glue/utils.h"

      int main(int argc, char* argv[]) {
        char *uuid = generate_uuid();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-limobiledevice-glue-1.0", "-o", "test"
    system "./test"
  end
end
