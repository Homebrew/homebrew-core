class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.0.2.tar.gz"
  sha256 "f1c48c336ca7300971619358f532367c7dabfc6e16b2b2bfc99646ed50271d93"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "2137bd868d09af1f8c85a40e5e83214412b87f3aa9d6182441e26976067c3a15"
    sha256 arm64_big_sur:  "5d3a73a5e72d16794a110d16f90697d7d328c2a2f8ec0bc81c5690c8f686b492"
    sha256 monterey:       "3d418309680dc8dadbeb9b1b57a892fe3a29c149c1ce6c1abf53464bc46c4c6f"
    sha256 big_sur:        "6edc95c38b0cbf9a4964e4b848c586299215234c2bf13638cd693b3430cd9595"
    sha256 catalina:       "4a47d36033bc5aefa81a7260ff256d83c016eac499fbb0c4d736b21091484dc3"
    sha256 x86_64_linux:   "b65d3f2d75e60556c6c6c2a16a15ef89921eb71eb511b2895e9c8ca89e206260"
  end

  depends_on "libre"
  depends_on "librem"

  def install
    # baresip doesn't like the 10.11 SDK when on Yosemite
    if MacOS::Xcode.version.to_i >= 7
      ENV.delete("SDKROOT")
      ENV.delete("HOMEBREW_SDKROOT") if MacOS::Xcode.without_clt?
    end

    libre = Formula["libre"]
    librem = Formula["librem"]
    # NOTE: `LIBRE_SO` is a directory but `LIBREM_SO` is a shared library.
    args = %W[
      PREFIX=#{prefix}
      LIBRE_MK=#{libre.opt_share}/re/re.mk
      LIBRE_INC=#{libre.opt_include}/re
      LIBRE_SO=#{libre.opt_lib}
      LIBREM_PATH=#{librem.opt_prefix}
      LIBREM_SO=#{librem.opt_lib/shared_library("librem")}
      MOD_AUTODETECT=
      USE_G711=1
      USE_OPENGL=1
      USE_STDIO=1
      USE_UUID=1
      HAVE_GETOPT=1
      V=1
    ]
    if OS.mac?
      args << "USE_AVCAPTURE=1"
      args << "USE_COREAUDIO=1"
    end
    system "make", "install", *args
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
