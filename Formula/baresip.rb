class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.4.0.tar.gz"
  sha256 "5939cdd5f37f164f2c3ccfdf4ae8f44d5aa40ed73c3517bdd88b080d575784b3"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "321d290cdadb236717d10039d2e25e910fb474dfb8d44b980299b0cfd665a9b9"
    sha256 arm64_big_sur:  "1b50c200ee7b13486a565c8148ee519f3d37dd0b8db0af0cecc989da8fc6cd7b"
    sha256 monterey:       "0bac6db7823cd63de85dc9d17dd5bfa263b92ba4d864f3365aecb88d2eff8132"
    sha256 big_sur:        "53f8e6447904119f08c416e7aa34853cb35521469e584e9925896bcf7a12cde9"
    sha256 catalina:       "5d532473248c52bd804641c3359dc1bbf6fb23b06237e47ffe3f1bdc245be33c"
    sha256 x86_64_linux:   "158223c2396ca16b610cf4ded297706a07eda075889f7064ef8d67c03d5e06d1"
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
