class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.12.2.tar.gz"
  sha256 "0b583ca546e4ae1896e6390c1a0ef53e7673b6ca6a5597502e9d1ba35f02c2ea"
  revision 2

  bottle do
    sha256 "71f81ecc7298760f4505feeb0da87c3e590a43fbd01d1c96694f8b84cd8f8e44" => :mojave
    sha256 "a25aa80684bac6366073d28d80c79be68b01b7c6aa1658a74ae63c56c5e2828e" => :high_sierra
    sha256 "1d241c37a4371db065ef43c47d4b9d9ad8e94622c4912be8d06391a565293745" => :sierra
  end

  depends_on "lmdb"
  depends_on "openssl"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.12.2.tar.gz"
    sha256 "1183c892e050c39645b7d79171fca8e829fba63628d29c3b776fc7840599573b"
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
