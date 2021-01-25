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
    sha256 "67bdde882244562579842da22d9e1a50708caeda776cfc2039f23abae34cd79b" => :big_sur
    sha256 "dcbfc690677dad4edb4054a38aa93297520fc9a5047979e232f8c3cc443f02d3" => :arm64_big_sur
    sha256 "0fffe31906626805cb526bfec833c96cb5fce1055bf4403e95e3df6cfb378e39" => :catalina
    sha256 "5547175a2bffb5013ca52344b3f2ecf58ec17ddf61e8ed7e482edb65c0ed03c5" => :mojave
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
