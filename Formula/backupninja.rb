class Backupninja < Formula
  desc "Backup automation tool"
  homepage "https://0xacab.org/riseuplabs/backupninja"
  url "https://0xacab.org/riseuplabs/backupninja/uploads/6c50939c6e0690d9f04ff19d8eb9364b/backupninja-1.1.0.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/b/backupninja/backupninja_1.1.0.orig.tar.gz"
  sha256 "abe444d0c7520ede7847b9497da4b1253a49579f59293b043c47b1dd9833280a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9018c721fb3774083fac0c4994afe6a0151bafaa5459242e37eec3c7c67a26dc" => :high_sierra
    sha256 "9018c721fb3774083fac0c4994afe6a0151bafaa5459242e37eec3c7c67a26dc" => :sierra
    sha256 "9018c721fb3774083fac0c4994afe6a0151bafaa5459242e37eec3c7c67a26dc" => :el_capitan
  end

  depends_on "dialog"
  depends_on "gawk"

  skip_clean "etc/backup.d"

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install", "SED=sed"
  end

  def post_install
    (var/"log").mkpath
  end

  test do
    assert_match "root", shell_output("#{sbin}/backupninja -h", 1)
  end
end
