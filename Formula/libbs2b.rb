class Libbs2b < Formula
  desc "Bauer stereophonic-to-binaural DSP"
  homepage "https://bs2b.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bs2b/libbs2b/3.1.0/libbs2b-3.1.0.tar.gz"
  sha256 "6aaafd81aae3898ee40148dd1349aab348db9bfae9767d0e66e0b07ddd4b2528"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "348394113062af5f31f9dfd6617f8d248b9bdeba11d28711d83e3e5d9326437f"
    sha256 cellar: :any,                 big_sur:       "b7cd734ae3c6870fc16092a076d343efd1325ff1188062d2a63971df783507c0"
    sha256 cellar: :any,                 catalina:      "61ba0d4bf4a016a7634256d2c7eef59d55dacb3f33730d8f2905f9fa35db0108"
    sha256 cellar: :any,                 mojave:        "b1236f81550a661e9b6ca6db5c828465d32cf0ca8e7db9504cb94871760c4a22"
    sha256 cellar: :any,                 high_sierra:   "0d2faffb7452ddd66d306746065dc7264d66c3e8f60a3525ee4eb911cd546bcd"
    sha256 cellar: :any,                 sierra:        "0431cb3f7cac90d18d854abe956ad296ba399832b733293e55ea58f0f11ba1b1"
    sha256 cellar: :any,                 el_capitan:    "7949aa7768466a789d992d079a63d5933d19e76ebfb330b38d3b4822929a71ac"
    sha256 cellar: :any,                 yosemite:      "62a45fde4ae7db34b1c14212d2c0ec5c603fdc403dc1df2b629972789dc7489e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d6af3a009939d61fdec9ddd863c4c6e8b51d4f3bd5bc73f55dfc76ac2f48231"
  end

  depends_on "pkg-config" => :build
  depends_on "libsndfile"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-static",
                          "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lbs2b", "-o", "test"
    system "./test"
  end
end
