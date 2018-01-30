class Libtrng < Formula
  desc "Tina's Random Number Generator Library"
  homepage "https://www.numbercrunch.de/trng/"
  url "https://www.numbercrunch.de/trng/trng-4.20.tar.gz"
  sha256 "8cffd03392a3e498fe9f93ccfa9ff0c9eacf9fd9d33e3655123852d701bbacbc"

  bottle do
    cellar :any
    sha256 "5ae8a961a4bc56da1347d97aff8f75f019a35f475cf756a7534ddb88fd151b15" => :high_sierra
    sha256 "ae717cd2fe16f077d13b6ea286d6ff5a4eaddc03829c88b2536e679a046302c3" => :sierra
    sha256 "f74d4d146c484604d4f33e43068ba8629bbea8757b63456cc8405ded55993e85" => :el_capitan
    sha256 "b34fb6439f66eec2f315d678208baf4444a1a89d82db2e485770ff3bea364895" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <trng/yarn2.hpp>
      #include <trng/normal_dist.hpp>
      int main()
      {
        trng::yarn2 R;
        trng::normal_dist<> normal(6.0, 2.0);
        (void)normal(R);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-ltrng4"
    system "./test"
  end
end
