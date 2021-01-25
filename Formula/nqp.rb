class Nqp < Formula
  desc "Lightweight Perl 6-like environment for virtual machines"
  homepage "https://github.com/perl6/nqp"
  # NOTE: Please keep these values in sync with moarvm & rakudo when updating.
  url "https://github.com/perl6/nqp/releases/download/2020.12/nqp-2020.12.tar.gz"
  sha256 "fd445b3c3b844a2fc523dc567b2a65c4dc2cc9a3f42ef2e860ef71174823068e"
  license "Artistic-2.0"

  bottle do
    rebuild 1
    sha256 "da4c1fbeebe3c51d26ae4bff6362cc9acd1bc4bfa0a6f72ec11fc38a08bf887d" => :big_sur
    sha256 "f4b25743bad14ec0cdd1a712f2fc0ceac16e9ffcf3f8122d1ea1aa5ec0c74308" => :arm64_big_sur
    sha256 "24e1c860b5c9c1bb85a0d20a89788100d24b39408b016acca3fc6f66fc6c37ff" => :catalina
    sha256 "e52cad208d6c1d12286ae32a11be4371a0d0ec1626b3480a7fc0fa34f1217df7" => :mojave
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
