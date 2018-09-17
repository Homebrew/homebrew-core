class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.12.0.tar.gz"
  sha256 "d71ba98a272390c6fa8bc20e8ea27f0050a0a72a3e6b206a4762b4646be332ec"

  bottle do
    sha256 "b1e2079b0bd8aa12ab6232d555c4707f4ccb0cb5ec8f771dffcc29d7bc900f6a" => :mojave
    sha256 "6d17d250d32a04ba47bd234abb1c5ee8d7fd69df1dfc517b1ab95c3995a270f3" => :high_sierra
    sha256 "67ee78d55c3b1e1877f0e03954dc270ff1874e0151d05d9a402365d118aa2bfa" => :sierra
    sha256 "468f1d8fc3726456fe25f14af8795e0410aa7bc558f7e841ce99082e738de149" => :el_capitan
  end

  depends_on "libxml2" if MacOS.version < :mountain_lion
  depends_on "lmdb"
  depends_on "openssl"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.12.0.tar.gz"
    sha256 "1c50e3d8c702097e13a21258626d936d6ff2e6492e893dfe286ff0d6204d7a65"
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
