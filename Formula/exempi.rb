class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.4.3.tar.bz2"
  sha256 "bfd1d8ebffe07918a5bfc7a5130ff82486d35575827cae8d131b9fa1c0c29c6e"

  bottle do
    cellar :any
    sha256 "fe7d28fde8e93803a7761660948481b4482890eef979e9b770ca515853fedede" => :sierra
    sha256 "810d605db2db422fd2b919d7eba26baf9e602ddb5da179a6477ed4e7c2e840a6" => :el_capitan
    sha256 "08d3671e3cd4e338196e2137419400069384fc30fa4813ae3cd10e0ce85dc604" => :yosemite
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
