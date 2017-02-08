class Cheops < Formula
  desc "CHEss OPponent Simulator"
  homepage "http://en.nothingisreal.com/wiki/CHEOPS"
  url "http://files.nothingisreal.com/software/cheops/cheops-1.2.tar.bz2"
  sha256 "60aabc9f193d62028424de052c0618bb19ee2ccfa6a99b74a33968eba4c8abad"

  bottle do
    cellar :any_skip_relocation
    sha256 "27d8ebc44571902b64043fdcc5c956f89df988e9311ad76eea6f66e2127d3898" => :sierra
    sha256 "aa996a9d23fb57b16bd744aef3746f76d3d3c0316f37ecd258b62d9a36a8b751" => :el_capitan
    sha256 "17d4673487be785e81e1a7cac0a9a3f371cd79cf870906c65d8bdb81fb1a5cc7" => :yosemite
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
