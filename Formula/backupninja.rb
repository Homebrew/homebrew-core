class Backupninja < Formula
  desc "Backup automation tool"
  homepage "https://0xacab.org/riseuplabs/backupninja"
  url "https://sourcearchive.raspbian.org/main/b/backupninja/backupninja_1.0.2.orig.tar.gz"
  mirror "https://debian.ethz.ch/ubuntu/ubuntu/pool/universe/b/backupninja/backupninja_1.0.2.orig.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/backupninja_1.0.2.orig.tar.gz"
  sha256 "fdb399de331493c8f959a784318349b19a01fbeece275da2ecd70ec9847a80b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc931f546efa005cd351b37688a7f82386524e6c78304889ecf426f045db3d2f" => :mojave
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
