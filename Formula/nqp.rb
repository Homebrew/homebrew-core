class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  # Note: Please keep these values in sync with moarvm & rakudo when updating.
  url "https://github.com/perl6/nqp/releases/download/2020.10/nqp-2020.10.tar.gz"
  sha256 "100c74c8a81117040c3a1b85ac99312008753c17faeeab7d69998bcf7cdb6059"
  license "Artistic-2.0"

  bottle do
    sha256 "e6c981123d2dac1718de6541bcc1afbabbffb790c97a7785aa56ac3af9a8744f" => :catalina
    sha256 "ec38507d0931044fde2a0884c234de8aabcc06c36460dbaf1e217ce0d08965dd" => :mojave
    sha256 "d62fe0804d0ea234e9302c4dd155a7d61259011463b196157f8280d657e39e26" => :high_sierra
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
