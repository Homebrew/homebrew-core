class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  # NOTE: Please keep these values in sync with moarvm & rakudo when updating.
  url "https://github.com/Raku/nqp/releases/download/2021.07/nqp-2021.07.tar.gz"
  sha256 "dcaaf2a43ab3b752be6f4147a88abdc5b897e5ba85e536a0282bde8e4d363ea4"
  license "Artistic-2.0"

  bottle do
    sha256 arm64_big_sur: "0d99267f131699d5bbae0f2ef1f8e4317862a5907e82d5418a3405751587be14"
    sha256 big_sur:       "24a88212b499b1af8d7b79ae5343cd0ec1444a6988ad317669b96a61cf385a10"
    sha256 catalina:      "e23236c616b4d75c082e79d86138fa6a8cb534eaf8919a4259e199e15005063d"
    sha256 mojave:        "5e07afdc719d2f47fa232e13d7ccb48a38e814c093de2f8facaa3aad7a9a88be"
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
