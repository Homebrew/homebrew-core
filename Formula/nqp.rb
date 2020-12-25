class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  # NOTE: Please keep these values in sync with moarvm & rakudo when updating.
  url "https://github.com/perl6/nqp/releases/download/2020.12/nqp-2020.12.tar.gz"
  sha256 "fd445b3c3b844a2fc523dc567b2a65c4dc2cc9a3f42ef2e860ef71174823068e"
  license "Artistic-2.0"

  bottle do
    sha256 "f374dfbf394b8238e126c75ceebebfb86285506d43818c2b3b869d531383ecd9" => :big_sur
    sha256 "d898cd5b76ecb0b5d0fb6fae918a76d1dd242551eaca8db7a9f4a534af1074b4" => :catalina
    sha256 "dd4a49183750cc951e994ee486ff2d2b76f84a68d7ab685c951c99692f381b00" => :mojave
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
