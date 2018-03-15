class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.11.0.tar.gz"
  sha256 "19524cf311c3cd7bf2d6c471c9b704c597671d2f89871d3d42302ba231de5865"

  bottle do
    sha256 "33e36292909af1f1bc2846e6f19b8109970c97a81b75a234d7c89626ec3d8e46" => :high_sierra
    sha256 "1eb3449cdf367e647bd31af2fa0987645db990bed26a97532d3eb89e13d95ef7" => :sierra
    sha256 "91378980884269d4cdd3f4b78ce625ff6fca01882a23ce0baf9e74e105ca77fc" => :el_capitan
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
