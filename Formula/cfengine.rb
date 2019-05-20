class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.12.2.tar.gz"
  sha256 "0285e039f576b4cf2c8a2f795fdb1687b7637e932bb1d963093546f2abee11b0"

  bottle do
    sha256 "b1f0f170fded3658090b247fb218ccff19bb55fe8c2830a52c5c8a6289a14e7d" => :mojave
    sha256 "f41038afe500dc930dec5c7b5abd6e10302ba16576e8fccbf0b2fa9a5be71ae6" => :high_sierra
    sha256 "f1c00381d6d6bd3e9ab1b8f297c838c8a07b3c521b922229b73cacd720d1ed51" => :sierra
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
