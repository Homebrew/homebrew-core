class Libgsm < Formula
  desc "Lossy speech compression library"
  homepage "http://www.quut.com/gsm/"
  url "http://www.quut.com/gsm/gsm-1.0.19.tar.gz"
  sha256 "4903652f68a8c04d0041f0d19b1eb713ddcd2aa011c5e595b3b8bca2755270f6"

  livecheck do
    url :homepage
    regex(/href=.*?gsm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6bc94981bf0d1334af48e47e8692d094367793b511a0df113a48266ab6f0c698"
    sha256 cellar: :any, big_sur:       "c5bee474fc90a4c08f5e0b7e3eb589c363501cd479f2fdb5369e37c7d0824539"
    sha256 cellar: :any, catalina:      "9a3eaa556cd1a5429c458ee11c29b5c757ee6f32fbc334355110a37622357dc4"
    sha256 cellar: :any, mojave:        "f7a7683ef5f7f916e81e3ed51aa754da92ca2b993533608f8fc95187baaf8b3c"
    sha256 cellar: :any, high_sierra:   "5a2b52e7ed65f005f32bb56519dd425b26e537f888b49402322fe1424f0901e4"
  end

  # Builds a dynamic library for gsm, this package is no longer developed
  # upstream. Patch taken from Debian and modified to build a dylib.
  patch do
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/3c6294a792d8d75f597631985370e147f5e22e8a/libgsm/libgsm_shared_mac.patch"
      sha256 "9580ec7939e23e179bf0dd82654a58f8476f411ea67d8fa62daa449689854955"
    end
    on_linux do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/2e76698620c3118cdd15036a9db3f86f78342878/libgsm/libgsm_shared_linux.patch"
      sha256 "1a9df9f9ceeeb1a813248ff5de00ddcc98f895f4d4bad671164450381d7bbd8c"
    end
  end

  def install
    ENV.append_to_cflags "-c -O2 -DNeedFunctionPrototypes=1"

    # Only the targets for which a directory exists will be installed
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath
    man3.mkpath

    # Dynamic library must be built first
    inreplace "Makefile", "@@SOVERSION@@", version
    library = if OS.mac?
      "libgsm.#{version}.dylib"
    else
      ENV.append_to_cflags "-fPIC"
      "libgsm.so"
    end
    system "make", "lib/#{library}",
           "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}",
           "LDFLAGS=#{ENV.ldflags}"
    system "make", "all",
           "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}",
           "LDFLAGS=#{ENV.ldflags}"
    system "make", "install",
           "INSTALL_ROOT=#{prefix}",
           "GSM_INSTALL_INC=#{include}"
    lib.install Dir["lib/#{shared_library("*")}"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gsm.h>

      int main()
      {
        gsm g = gsm_create();
        if (g == 0)
        {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgsm", "-o", "test"
    system "./test"
  end
end
