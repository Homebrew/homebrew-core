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
    sha256 cellar: :any, arm64_monterey: "560c62fce828d0f2fb3a4f83069aff197bb6edad19d863aedd0bdca1754ee547"
    sha256 cellar: :any, arm64_big_sur:  "6bc94981bf0d1334af48e47e8692d094367793b511a0df113a48266ab6f0c698"
    sha256 cellar: :any, monterey:       "747544181743e7a85f21ee67ca53b7f94652612c872a7b5eaef1525cff2e5731"
    sha256 cellar: :any, big_sur:        "c5bee474fc90a4c08f5e0b7e3eb589c363501cd479f2fdb5369e37c7d0824539"
    sha256 cellar: :any, catalina:       "9a3eaa556cd1a5429c458ee11c29b5c757ee6f32fbc334355110a37622357dc4"
    sha256 cellar: :any, mojave:         "f7a7683ef5f7f916e81e3ed51aa754da92ca2b993533608f8fc95187baaf8b3c"
    sha256 cellar: :any, high_sierra:    "5a2b52e7ed65f005f32bb56519dd425b26e537f888b49402322fe1424f0901e4"
  end

  # Builds a dynamic library for gsm, this package is no longer developed
  # upstream. Patch taken from Debian and modified to build a dylib.
  patch do
    url "https://gist.githubusercontent.com/dholm/5840964/raw/1e2bea34876b3f7583888b2284b0e51d6f0e21f4/gistfile1.txt"
    sha256 "3b47c28991df93b5c23659011e9d99feecade8f2623762041a5dcc0f5686ffd9"
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
    system "make", "lib/libgsm.1.0.13.dylib",
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
    system ENV.cc, "-L#{lib}", "-lgsm", "test.c", "-o", "test"
    system "./test"
  end
end
