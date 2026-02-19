class Libvdpau < Formula
  desc "Open source Video Decode and Presentation API library"
  homepage "https://www.freedesktop.org/wiki/Software/VDPAU/"
  url "https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/1.5/libvdpau-1.5.tar.bz2"
  sha256 "a5d50a42b8c288febc07151ab643ac8de06a18446965c7241f89b4e810821913"
  license "MIT"

  livecheck do
    url :stable
    regex(/^(?:libvdpau[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "f9726bd90703d99de544a8ad2b2f4e043b547a82af7887ed0d220d8f011612e4"
    sha256 arm64_sequoia:  "8baf9479a1307dd3f6819d5953b200195a91d7c522f01b2b4930e9fc750b3615"
    sha256 arm64_sonoma:   "a683463e26fbc2b4d4d56865835d0aa94316c556aa56c1dc55263e307b8bc4cc"
    sha256 arm64_ventura:  "2e414f4fcb57c924669fae785354d36899e13cbb11375ad24483001ed0e0f19d"
    sha256 arm64_monterey: "983ddb3ecfdacb086fd056315553adf0e458e6f4da959a0381d4889e55947635"
    sha256 arm64_big_sur:  "d474b20b3cd5675c303af15e353b2e23b4107fb43660de06fdca174c2b8a6ac7"
    sha256 sonoma:         "4e529c0af6669f6df022900daaed25245415be288c7d27e57e5cb1f737d1e77b"
    sha256 ventura:        "b17967b5626752a517b629d7c01e002eba4bd9ea5bcc756f935ad5f3326543c5"
    sha256 monterey:       "b1ca92eb755c147f47c63a590705159a099cb74f97b0bb3260e26e46979acd04"
    sha256 big_sur:        "19e0e92759c99ab2942d2b750bd32065b31829015bee25c384929a12f9eea5ca"
    sha256 catalina:       "d5bdf31825ef0083a0a426f98de307d1f00376804d03e020d096bee5da273def"
    sha256 arm64_linux:    "298a8659f47956680197cbcaa0c06efe10ac94b863c0e1c62bf680390315d024"
    sha256 x86_64_linux:   "efe7bfed2aff2b6b4d259a9adc1601a17c8c567750a2dfa0ba354a7d9ba0ca42"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end
  test do
    assert_match "-I#{include}", shell_output("pkgconf --cflags vdpau")
  end
end
