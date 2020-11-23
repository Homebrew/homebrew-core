class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.17.0.tar.gz"
  sha256 "b7def98c2bdf491839a6dfb85ac48c670136cf331984b6c4063551ed3daf1420"

  livecheck do
    url "https://cfengine.com/release-data/community/releases.json"
    regex(/"version": ?"(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    sha256 "f89f448c20951a96e061ec06cc73682144c15a93a42b93eaf18b8118ec0d03f4" => :big_sur
    sha256 "0ab2ee4f191720ab6e546f05235449a62c0435c5897a1d9bd271ba5de2d6192b" => :catalina
    sha256 "11ffdc33ab4a8004aed11a71545dfb230c15c1a07780b73955a7095df223c2e0" => :mojave
    sha256 "359f56d367aa77a65b089616556c7caf02aff9144fcbfc1eb208b2582d5a1ba5" => :high_sierra
  end

  depends_on "lmdb"
  depends_on "openssl@1.1"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.17.0.tar.gz"
    sha256 "03a67dda0dfa8bc060c65e9ae8c6c4e7bf29711aeee5c62ed45dfa570513aa57"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-workdir=#{var}/cfengine",
                          "--with-lmdb=#{Formula["lmdb"].opt_prefix}",
                          "--with-pcre=#{Formula["pcre"].opt_prefix}",
                          "--without-mysql",
                          "--without-postgresql"
    system "make", "install"
    (pkgshare/"CoreBase").install resource("masterfiles")
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
