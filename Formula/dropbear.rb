class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2019.78.tar.bz2"
  sha256 "525965971272270995364a0eb01f35180d793182e63dd0b0c3eb0292291644a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f63323d955182c40f86c6e0c681da9628780db8803f8812e422c72af5e6ddfd" => :mojave
    sha256 "c2440ba5427b079dc3ca2a56f84c53fed4c1cff689df0fc53d2e0c6de1f983c7" => :high_sierra
    sha256 "5764f9837f9a8a330cba257657b93b410d76b5e184dab8971b6772594ff5182c" => :sierra
    sha256 "51840945255b14f841843c9061448542054589284d907632c0fbd41cd38be405" => :el_capitan
  end

  head do
    url "https://github.com/mkj/dropbear.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    ENV.deparallelize

    if build.head?
      system "autoconf"
      system "autoheader"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}/dropbear"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath/"testec521"
    system "#{bin}/dbclient", "-h"
    system "#{bin}/dropbearkey", "-t", "ecdsa", "-f", testfile, "-s", "521"
    assert_predicate testfile, :exist?
  end
end
