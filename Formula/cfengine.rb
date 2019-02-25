class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.12.1.tar.gz"
  sha256 "20bd406bbf79b0939e4232a9ff385443d7d286f36f8c9a8e54e18b7ad0797829"

  bottle do
    sha256 "b1e2079b0bd8aa12ab6232d555c4707f4ccb0cb5ec8f771dffcc29d7bc900f6a" => :mojave
    sha256 "6d17d250d32a04ba47bd234abb1c5ee8d7fd69df1dfc517b1ab95c3995a270f3" => :high_sierra
    sha256 "67ee78d55c3b1e1877f0e03954dc270ff1874e0151d05d9a402365d118aa2bfa" => :sierra
    sha256 "468f1d8fc3726456fe25f14af8795e0410aa7bc558f7e841ce99082e738de149" => :el_capitan
  end

  depends_on "lmdb"
  depends_on "openssl"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.12.1.tar.gz"
    sha256 "260980d462d3b8688d98a5b79d28abed09c9d0ae72c750f20153ef4e981f6bf6"
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
