class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.16.0.tar.gz"
  sha256 "f4256e6e1ca04776a9fd48f1388a30edfa8d11fdcf870ba62ce5b0ad62a87372"

  livecheck do
    url "https://cfengine.com/release-data/community/releases.json"
    regex(/"version": ?"(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    sha256 "0ab2ee4f191720ab6e546f05235449a62c0435c5897a1d9bd271ba5de2d6192b" => :catalina
    sha256 "11ffdc33ab4a8004aed11a71545dfb230c15c1a07780b73955a7095df223c2e0" => :mojave
    sha256 "359f56d367aa77a65b089616556c7caf02aff9144fcbfc1eb208b2582d5a1ba5" => :high_sierra
  end

  depends_on "lmdb"
  depends_on "openssl@1.1"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.16.0.tar.gz"
    sha256 "2f63ad1ee2d49af651c0911fc44778cbebb5a1afd33f5f93fa4644e71322a091"
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
