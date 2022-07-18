class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.5.0.tar.gz"
  sha256 "2429a403c0b27c5b1a7849ea38bdc72c1921261f7e8880c892a207d4d63fa6fd"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "d1e629a6cdc5ff184f40b02d424928d53dfeb7c8f2ed84d4fc0172445e611340"
    sha256 arm64_big_sur:  "0456015d675dcef51849a8b3b3da536513163b5b36876d54ce53474a9cf67b56"
    sha256 monterey:       "eb88663abe1e7f92e337cafa62798c5fafc115e0400897c3c70c3aea52bc82db"
    sha256 big_sur:        "00b79ef3750be4c94cf55fdeefd7c83bb8183b6f6dad138c7a5f186c9958cc70"
    sha256 catalina:       "f5fb23743cada9b30fdcda0db5a3cdfce659ea1af9bbf7ba04187564a3b4208e"
    sha256 x86_64_linux:   "07b545ed19c1dfadabc8629a6eb596e1ea1ec5fc3698286635b0b478d0bbc90c"
  end

  depends_on "libre"
  depends_on "librem"

  def install
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
