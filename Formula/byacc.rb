class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "http://invisible-island.net/byacc/byacc.html"
  url "ftp://invisible-island.net/byacc/byacc-20170201.tgz"
  sha256 "90b768d177f91204e6e7cef226ae1dc7cac831b625774cebd3e233a917754f91"

  bottle do
    cellar :any_skip_relocation
    sha256 "62b3f87a17d1fa2309444b295b3f1b92e2c2afaa8566effbdf2f3dd7f06a3052" => :sierra
    sha256 "9fde660e4a2eac410064b77801c364cc3c7dbb9a0fabe1c5aa929aeb1aec6808" => :el_capitan
    sha256 "59e8adc373dd31b8087d6a82fa2c6fcb7c50f21d23b2c65d6f91f9d72b754211" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
