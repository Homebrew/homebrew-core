class Libvdpau < Formula
  desc "Open source Video Decode and Presentation API library"
  homepage "https://www.freedesktop.org/wiki/Software/VDPAU/"
  url "https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/1.5/libvdpau-1.5.tar.bz2"
  sha256 "a5d50a42b8c288febc07151ab643ac8de06a18446965c7241f89b4e810821913"
  license "MIT"

  livecheck do
    url "https://gitlab.freedesktop.org/vdpau/libvdpau.git"
    regex(/^(?:libvdpau[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "2e414f4fcb57c924669fae785354d36899e13cbb11375ad24483001ed0e0f19d"
    sha256 arm64_monterey: "983ddb3ecfdacb086fd056315553adf0e458e6f4da959a0381d4889e55947635"
    sha256 arm64_big_sur:  "d474b20b3cd5675c303af15e353b2e23b4107fb43660de06fdca174c2b8a6ac7"
    sha256 ventura:        "b17967b5626752a517b629d7c01e002eba4bd9ea5bcc756f935ad5f3326543c5"
    sha256 monterey:       "b1ca92eb755c147f47c63a590705159a099cb74f97b0bb3260e26e46979acd04"
    sha256 big_sur:        "19e0e92759c99ab2942d2b750bd32065b31829015bee25c384929a12f9eea5ca"
    sha256 catalina:       "d5bdf31825ef0083a0a426f98de307d1f00376804d03e020d096bee5da273def"
    sha256 x86_64_linux:   "efe7bfed2aff2b6b4d259a9adc1601a17c8c567750a2dfa0ba354a7d9ba0ca42"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end
  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags vdpau")
  end
end
