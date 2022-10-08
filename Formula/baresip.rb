class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.8.1.tar.gz"
  sha256 "facd2b0e30d81a08fc509f2fb1d1da5441d1660ed0d329d32420be7e70be4398"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "bd8358d607e8d58c615c1d5b1ea12788dc70caa13969729d1e30ec420ef33e5c"
    sha256 arm64_big_sur:  "eab11582f6495cd4d94e6527f40ac28d435e8e8d5ba2db99314d7c036cfb29d2"
    sha256 monterey:       "0048a9d941aa49a64a72241329ec0795aee10c76feb882abc08635c60970315f"
    sha256 big_sur:        "75589392663f8790e907f41a88fb231058600c414cccc9d09a946fddfbc2ff24"
    sha256 catalina:       "e8490f9435206cd7c8a5e8b1e1578e3f4a133e1df714f24fe86040dfb6d93a93"
    sha256 x86_64_linux:   "294cf68f63935493e137cedd140d070be8cbd6b706d4a4b654484092035cdea7"
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
