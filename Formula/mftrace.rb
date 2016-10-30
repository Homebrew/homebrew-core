class Mftrace < Formula
  desc "Trace TeX bitmap font to PFA, PFB, or TTF font"
  homepage "http://lilypond.org/mftrace/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mftrace/mftrace_1.2.18.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/m/mftrace/mftrace_1.2.18.orig.tar.gz"
  sha256 "0d31065f1d35919e311d9170bbfcdacc58736e3f783311411ed1277aa09d3261"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bcb02aa4645912fe6c0201e4a89ea30cb5313a674d80c231778b7fa31378ec2c" => :sierra
    sha256 "ad6f46655a7124478dc7ef6a3c1155e98651e0e09417c6092bcb964d9b2d0c66" => :el_capitan
    sha256 "cfd1f6865fb61eb8a3e3b56732859387537553bb26c61ecad9c0499ef34be82a" => :yosemite
  end

  head do
    url "https://github.com/hanwen/mftrace.git"
    depends_on "autoconf" => :build
  end

  depends_on "potrace"
  depends_on "t1utils"
  depends_on "fontforge" => [:recommended, :run]

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mftrace", "--version"
  end
end
