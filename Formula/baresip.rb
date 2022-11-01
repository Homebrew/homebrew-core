class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "b4ca604f47f67b1390c9549768d54c2359ec3e56874db87b47ac6d8a022abcb3"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "62295fd60ac100eaaa0536ae018b7579cedfe8f5ee9e92cbfde0ea5502d40a63"
    sha256 arm64_big_sur:  "f71d9ed2918760a2e5f0bb10bb14e55fbb88320c880adb750844bbe86d60c098"
    sha256 monterey:       "dc3935ceb324f3a6d9c26b85913d278641a5667c6c4b5b9ad6bbed1384d9c604"
    sha256 big_sur:        "5f89590a6751d0a489309b9460d541198cad646853ca759ef42932691d8ec425"
    sha256 catalina:       "5b3dcd6a600ffb19097bd5c0386b1ad76449d14b3f1b1894ee1492804c955203"
    sha256 x86_64_linux:   "1b0967fcf830f3d5a18c7e0dfb342ee71a9b9840e49d876205ecd6ebf5ac97e6"
  end

  depends_on "libre"
  depends_on "librem"

  def install
    libre = Formula["libre"]
    librem = Formula["librem"]
    args = %W[
      PREFIX=#{prefix}
      LIBRE_MK=#{libre.opt_share}/re/re.mk
      LIBRE_INC=#{libre.opt_include}/re
      LIBRE_SO=#{libre.opt_lib}
      LIBREM_PATH=#{librem.opt_prefix}
      LIBREM_SO=#{librem.opt_lib}
      MOD_AUTODETECT=
      USE_G711=1
      USE_OPENGL=1
      USE_STDIO=1
      USE_UUID=1
      HAVE_GETOPT=1
      RELEASE=1
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
