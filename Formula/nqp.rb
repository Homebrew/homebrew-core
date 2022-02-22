class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2022.02/nqp-2022.02.tar.gz"
  sha256 "25d3c99745cd84f4049a9bd9cf26bb5dc817925abaafe71c9bdb68841cdb18b1"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_monterey: "83cbb6ee55df08529dea5cca71affed02eadfb43c220f09507ea62e926871280"
    sha256 arm64_big_sur:  "d5d5978f0e615fe8b3c025c009332abf1218276409a5e897fe69232c36e33118"
    sha256 monterey:       "3e449242b4202a403c3fcd39c1729770f80d4c7c62840bd6b4858b09e7838be6"
    sha256 big_sur:        "6746068c6c8dee7d9b348b91d83768f8e4a4e7f25de1c3b27d077ed7f626fbd2"
    sha256 catalina:       "bd27609db30fa8a17e20102817ceb28658633f9271e0cd22d334654ba1ddf555"
    sha256 x86_64_linux:   "163368f3774f31d8538a7e0eda2c6e88e39d6e81aa6ec8bb06652f27a5059ce3"
  end

  depends_on "libtommath"
  depends_on "moarvm"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
