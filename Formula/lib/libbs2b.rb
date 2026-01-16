class Libbs2b < Formula
  desc "Bauer stereophonic-to-binaural DSP"
  homepage "https://bs2b.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/bs2b/libbs2b/3.1.0/libbs2b-3.1.0.tar.gz"
  sha256 "6aaafd81aae3898ee40148dd1349aab348db9bfae9767d0e66e0b07ddd4b2528"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "1ba28dd968f0cee9f5e12adef12978ac728db271ffe588218ccd59ac8e3a3afe"
    sha256 cellar: :any,                 arm64_sequoia:  "45676722780a091419361b9966b69511a1f0c7c6d9703ab72d7178711fbf749a"
    sha256 cellar: :any,                 arm64_sonoma:   "63ef89f0f1b41aea4ca096bba70fc2995da8c28845ffe9f57de8b0e51a3407c3"
    sha256 cellar: :any,                 arm64_ventura:  "550fc0d9af3d05be26435c1e7393a2d523775d0e2ed9af1cbe4791ed324ea9ca"
    sha256 cellar: :any,                 arm64_monterey: "be6c28752ed45916a1e7aec26599d0b08248d5b5409df335f1df1287956fcbd6"
    sha256 cellar: :any,                 arm64_big_sur:  "348394113062af5f31f9dfd6617f8d248b9bdeba11d28711d83e3e5d9326437f"
    sha256 cellar: :any,                 sonoma:         "1f07651dd674bbccd300375b9c2405f6e116444763f1964be66cc64ee905c6c3"
    sha256 cellar: :any,                 ventura:        "cb6f81bd34f41b0722bcc53e37f07bdb2b6c876dacdb56056de8c59368eca7da"
    sha256 cellar: :any,                 monterey:       "f4089cd8eb97c9f9f446b3402aa11a2cf920cfe95dc818534c9444b6fd2bba4a"
    sha256 cellar: :any,                 big_sur:        "b7cd734ae3c6870fc16092a076d343efd1325ff1188062d2a63971df783507c0"
    sha256 cellar: :any,                 catalina:       "61ba0d4bf4a016a7634256d2c7eef59d55dacb3f33730d8f2905f9fa35db0108"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2595f81bf293833f6aea6611164a1ca362517cf89e3ed64862c9171cb9390ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d6af3a009939d61fdec9ddd863c4c6e8b51d4f3bd5bc73f55dfc76ac2f48231"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libsndfile"

  def install
    # fix 'error: support for lzma-compressed distribution archives has been removed'
    inreplace "configure.ac", "dist-lzma", ""
    system "autoreconf", "--force", "--verbose", "--install"

    system "./configure", "--disable-static", "--enable-shared", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <bs2b/bs2b.h>

      int main()
      {
        t_bs2bdp info = bs2b_open();
        if (info == 0)
        {
          return 1;
        }
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lbs2b", "-o", "test"
    system "./test"
  end
end
