class Backupninja < Formula
  desc "Backup automation tool"
  homepage "https://0xacab.org/riseuplabs/backupninja"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/b/backupninja/backupninja_1.0.2.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/b/backupninja/backupninja_1.0.2.orig.tar.gz"
  sha256 "fdb399de331493c8f959a784318349b19a01fbeece275da2ecd70ec9847a80b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a4a20cb6085bcd8e341b480286f6a0f1d13200741d1e60a4c15ff8d2463d75f" => :high_sierra
    sha256 "844d6f69b560ddc0cbe0292e962c4b9613640d6730704ec8c8144261e0ce15e4" => :sierra
    sha256 "4e0b131e37240d5959ad09bbb105661ba9f8fffa1f058ffe46f2fe9729095a4e" => :el_capitan
    sha256 "e8ff74c3251e60e04a719be0b5e64a0ef8a6688d58dc4fb902baacf9cdcc4bf9" => :yosemite
    sha256 "88435f7cc59965f314fa3124ac759e2fb986736ffd066dfe83546ec81b367336" => :mavericks
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
