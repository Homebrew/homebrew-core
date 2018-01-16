class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.11.0.tar.gz"
  sha256 "19524cf311c3cd7bf2d6c471c9b704c597671d2f89871d3d42302ba231de5865"

  bottle do
    sha256 "2f3f54145ff6fc4b6e7892de3d0895e3ffb353f35953a1c2ae943ab0802b916c" => :high_sierra
    sha256 "c20e03c47ec3c2d5e580dbef1b60cdab5619aab548b92904e1fc3f4e20308b74" => :sierra
    sha256 "3146afa8ef4e2c5cedc7861dece69a9dc51f4fb4724b724363a616a600b6045f" => :el_capitan
    sha256 "a3a2527726612948e9ca8e6f82ef5bd6d21c53780b8c618db2c0455b0aa7e19c" => :yosemite
  end

  depends_on "libxml2" if MacOS.version < :mountain_lion
  depends_on "pcre"
  depends_on "lmdb"
  depends_on "openssl"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.11.0.tar.gz"
    sha256 "052a25d8dc9f2480825a4c6097e9db74762d6726afc163fbc1fef010bb6adab8"
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
