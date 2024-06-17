class Ivykis < Formula
  desc "Async I/O-assisting library"
  homepage "https://sourceforge.net/projects/libivykis/"
  url "https://github.com/buytenh/ivykis/archive/refs/tags/v0.43.1-trunk.tar.gz"
  sha256 "49b61734b8e5393b720f77258e8cf296e3b4a69cb895316412119b43f645751e"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]trunk)?$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a662957ac9241286446b5a81f850018291b81a60ddacd0f7a1bd9fc0588d3af8"
    sha256 cellar: :any,                 arm64_ventura:  "be1032e9dde0d14fab62bb6ac813c912be920059de51f64e7c86978e65b03859"
    sha256 cellar: :any,                 arm64_monterey: "7842e410ce7db58992a14bcd22dae66ede44eb90573ceea44b593cdb59b6f10e"
    sha256 cellar: :any,                 sonoma:         "13eefc45aa88a857b0578d0bac4e84942ef0a0a987583dfb8685bdf6bbb0b1f4"
    sha256 cellar: :any,                 ventura:        "1d2ec331ab0210d70a43ac32e96668446446e709db5bc97ce37a26a06f0532fc"
    sha256 cellar: :any,                 monterey:       "5b0e83de9da42c79b5c957874397307ebe76bbe236ecd806b12ef05d17c47b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeaf2cd478a3a19d693b26c8a48f5e2744ce0afab93769199172b19ac4e39a91"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test_ivykis.c").write <<~EOS
      #include <stdio.h>
      #include <iv.h>
      int main()
      {
        iv_init();
        iv_deinit();
        return 0;
      }
    EOS
    system ENV.cc, "test_ivykis.c", "-L#{lib}", "-livykis", "-o", "test_ivykis"
    system "./test_ivykis"
  end
end
