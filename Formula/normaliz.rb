class Normaliz < Formula
  desc "Open source tool for computations in abstract algebra"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.8.10/normaliz-3.8.10.tar.gz"
  sha256 "d085c64bebcb23e1c607ca1daff4551a9d38dd8f3dfbef4ef49670b58bb27f65"
  license "GPL-3.0-only"

  depends_on "flint"
  depends_on "gmp"
  depends_on "nauty"

  def install
    args = std_configure_args + %W[
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-flint=#{Formula["flint"].opt_prefix}
      --with-nauty=#{Formula["nauty"].opt_prefix}
    ]
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"2cone.in").write <<~EOS
      amb_space 2
      cone 2
      1 3
      2 1
    EOS
    system bin/"normaliz", "2cone.in"
    assert_predicate testpath/"2cone.out", :exist?
  end
end
