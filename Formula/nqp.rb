class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  # NOTE: Please keep these values in sync with moarvm & rakudo when updating.
  url "https://github.com/perl6/nqp/releases/download/2020.10/nqp-2020.10.tar.gz"
  sha256 "100c74c8a81117040c3a1b85ac99312008753c17faeeab7d69998bcf7cdb6059"
  license "Artistic-2.0"

  bottle do
    sha256 "bc47c3020f1057e6e668b006112eaf24685f56fcd89b3fc1dee4db59ea59b1d5" => :catalina
    sha256 "88974a7300f31c0c9ad8ec4f7674cd78a4170cfa47498cc11f140921f7171f88" => :mojave
    sha256 "4e41bdb3de219a926474ee0b086d2de88a896c866d7c048e1b35ac2137fa282a" => :high_sierra
  end

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
