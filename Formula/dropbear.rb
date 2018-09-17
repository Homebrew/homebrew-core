class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  revision 1

  stable do
    url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2018.76.tar.bz2"
    sha256 "f2fb9167eca8cf93456a5fc1d4faf709902a3ab70dd44e352f3acbc3ffdaea65"

    # Fixes CVE-2018-15599. Safe to remove on next release.
    # https://lists.ucc.gu.uwa.edu.au/pipermail/dropbear/2018q3/002108.html
    patch do
      url "https://secure.ucc.asn.au/hg/dropbear/raw-rev/5d2d1021ca00"
      sha256 "42b5720cf6c888638cfb84fdd862fc0d323b2e023cbe5f9ccdaa2e0c35b6873e"
    end
  end

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
