class Backupninja < Formula
  desc "Backup automation tool"
  homepage "https://0xacab.org/riseuplabs/backupninja"
  url "https://sourcearchive.raspbian.org/main/b/backupninja/backupninja_1.1.0.orig.tar.gz"
  mirror "https://debian.ethz.ch/ubuntu/ubuntu/pool/universe/b/backupninja/backupninja_1.1.0.orig.tar.gz"
  sha256 "abe444d0c7520ede7847b9497da4b1253a49579f59293b043c47b1dd9833280a"

  bottle do
    cellar :any_skip_relocation
    sha256 "10006896f517296c2a62d1f510d3795afa2777f24d401206cfb69ce06bdf5d3c" => :catalina
    sha256 "39df0693351a58ac9f406d6c16ab9c15ddb5d96ddf7ac9e98cf94061ccffe9a8" => :mojave
    sha256 "39df0693351a58ac9f406d6c16ab9c15ddb5d96ddf7ac9e98cf94061ccffe9a8" => :high_sierra
    sha256 "071ac37b853475ae44c4b3dde995d694a5fce322e68d7eeb39eb52a85c781cea" => :sierra
  end

  depends_on "bash"
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
