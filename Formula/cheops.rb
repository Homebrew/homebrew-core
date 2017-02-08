class Cheops < Formula
  desc "CHEss OPponent Simulator"
  homepage "http://en.nothingisreal.com/wiki/CHEOPS"
  url "http://files.nothingisreal.com/software/cheops/cheops-1.2.tar.bz2"
  sha256 "60aabc9f193d62028424de052c0618bb19ee2ccfa6a99b74a33968eba4c8abad"

  bottle do
    cellar :any
    sha256 "1640d418df9b54a929efb7a176acd01e05b17a032cc5bf3a259044c800ea7f82" => :yosemite
    sha256 "97bbc31c165d2cfa37d87bfea045e459ae98bcb0f8c1f01d07dd3620bf60831d" => :mavericks
    sha256 "7584ac4bcb11e2d3bf970dca2da588eb5c1c5f9bcd63e1305f71fef12c56d72d" => :mountain_lion
  end

  def install
    # Avoid ambiguous std::move issue with libc++
    ENV.libstdcxx

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cheops", "--version"
  end
end
