class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.9.0.tar.gz"
  sha256 "32a38aedf1199c2361e1335e0d4a1d98f9efa7cd591bcb647f35c7395bb66f2d"

  bottle do
    cellar :any
    sha256 "82b937ae5f95320c0dc70942a022d21bcf07794394cd87b2d878ca348791d1ab" => :el_capitan
    sha256 "cd7e4ea9521f133e207b8dfb1fda1cc571cd4f2ed9a4be5dd128622193790ce0" => :yosemite
    sha256 "eff5d4c4f4713df4aa5f862b5c2d9c6fade5c507d8a323b41e0618236cdd0ef8" => :mavericks
  end

  depends_on "libxml2" if MacOS.version < :mountain_lion
  depends_on "pcre"
  depends_on "lmdb"
  depends_on "openssl"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.9.0.tar.gz"
    sha256 "63dec2f8649f5f2788cd463dccf47f8dbe941522acfcf3093517f983bbfa0606"
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
