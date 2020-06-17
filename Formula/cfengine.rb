class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.15.2.tar.gz"
  sha256 "d1c570b7a0f47794a92f66e21cccdc86b8f56a7028a389780e705db41bfd3cab"

  bottle do
    sha256 "783eacd961c402e7565fa15bd46e7efd685d3efaa726b67b39da5b3b45a36f05" => :catalina
    sha256 "889174df90c768ba5f636e9d5e25a1875de7554de759bdd83db188a6151f0eb8" => :mojave
    sha256 "df9382ac5c4ed17eea80ec5dd998e3903d061a15afb347534bdbe9eaf0cd0fc5" => :high_sierra
  end

  depends_on "lmdb"
  depends_on "openssl@1.1"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.15.1.tar.gz"
    sha256 "051369054a2e17a4ea1f68a41198fe5377fbbf33f600168246bf0b667fc1ab74"
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
