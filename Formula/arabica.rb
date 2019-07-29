class Arabica < Formula
  desc "XML toolkit written in C++"
  homepage "https://www.jezuk.co.uk/cgi-bin/view/arabica"
  url "https://github.com/jezhiggins/arabica/archive/2016-January.tar.gz"
  version "20160214"
  sha256 "addcbd13a6f814a8c692cff5d4d13491f0b12378d0ee45bdd6801aba21f9f2ae"
  head "https://github.com/jezhiggins/arabica.git"

  bottle do
    cellar :any
    sha256 "448e31922f8c9b913ca5ca450599bfd631ed9781007cb7ff64fe69f14014cc27" => :mojave
    sha256 "0d3da860ba0b953abb9f70665cc73620ae2b0cd0570dacb55bfe8954ae0d58e7" => :high_sierra
    sha256 "6a08cb5b8af8d2034569451ad499260acebc610ab390383b20398fc10a6fb115" => :sierra
    sha256 "185edd120b5759f25d1e69b9f24840eef6a404b1001c90e684546e359cf75928" => :el_capitan
    sha256 "1882f30edf8da8d98df603a6006c3dce96e21941e4266103366930b3e5a922c2" => :yosemite
    sha256 "5d247d4d5819106404bc7091e3b6141b4d298c77636bee39bfc524a3c5481e7f" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  uses_from_macos "expat"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/mangle")
    assert_match "mangle is an (in-development) XSLT processor", output
  end
end
