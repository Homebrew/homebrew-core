class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.9.5.tar.gz"
  sha256 "6b451825b41d2f8b29592c08d671999527bf936789c599d77b8dfdc663f1e617"

  bottle do
    sha256 "c8e1e3c1da64c35a7ecb8696e4cf31113112887fff6f1b16a193900f50ac73e6" => :high_sierra
    sha256 "1ae613ef98c71ce691906dc7cf5282374bfa18cc669e8570b77152648bc3d8c7" => :sierra
    sha256 "b5426e62d5db7181898d371c444889127e6e7a9336b40020ca65d51cb0f55006" => :el_capitan
  end

  depends_on "gmp"
  depends_on "readline"
  depends_on :x11

  def install
    readline = Formula["readline"].opt_prefix
    gmp = Formula["gmp"].opt_prefix
    system "./Configure", "--prefix=#{prefix}",
                          "--with-gmp=#{gmp}",
                          "--with-readline=#{readline}"
    # make needs to be done in two steps
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"math.tex").write "$k_{n+1} = n^2 + k_n^2 - k_{n-1}$"
    system bin/"tex2mail", testpath/"math.tex"
  end
end
