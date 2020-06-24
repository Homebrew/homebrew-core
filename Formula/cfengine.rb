class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.16.0.tar.gz"
  sha256 "f4256e6e1ca04776a9fd48f1388a30edfa8d11fdcf870ba62ce5b0ad62a87372"

  bottle do
    sha256 "1a1376f997d783d0ecfbb59f4061059c11bce6fb9ff6b50b412b9e6008e35bad" => :catalina
    sha256 "b4476e20cc48c9d4f936b28f322d78b874d2778a619ffa625dda725c4259642c" => :mojave
    sha256 "6bfbee4fde430d242c8178dc2805ea6491afa52cb81e7c042b6032e9b52e9754" => :high_sierra
  end

  depends_on "lmdb"
  depends_on "openssl@1.1"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.16.0.tar.gz"
    sha256 "2f63ad1ee2d49af651c0911fc44778cbebb5a1afd33f5f93fa4644e71322a091"
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
