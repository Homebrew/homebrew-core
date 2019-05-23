class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.12.2.tar.gz"
  sha256 "0285e039f576b4cf2c8a2f795fdb1687b7637e932bb1d963093546f2abee11b0"

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
    sha256 "4abeeb23f6c5c50bed6ece5e2ba09d3d485ccccfff88852bf8d2668c73ef2caa"
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
