class Backupninja < Formula
  desc "Backup automation tool"
  homepage "https://0xacab.org/liberate/backupninja"
  url "https://0xacab.org/liberate/backupninja/-/archive/backupninja_upstream/1.2.2/backupninja-backupninja_upstream-1.2.2.tar.gz"
  sha256 "93ddc72f085d46145b289d35dac1d72e998c15bec1833db78e474b53c9768774"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^backupninja[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9200901794d73bd35ef083d40452e6c1b740c43634c97d5df84b1771a66d61ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcf6a2f362c138eeda64773965a94b261c63dc8850cd15bd3063f0ad840614d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ce80b2e23b07df75d4d11651c7c819c27ab5673189114aa72da8f28f96e2732"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ce80b2e23b07df75d4d11651c7c819c27ab5673189114aa72da8f28f96e2732"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ce80b2e23b07df75d4d11651c7c819c27ab5673189114aa72da8f28f96e2732"
    sha256 cellar: :any_skip_relocation, sonoma:         "17d638fdf1e6c0b4463f8b7dac5ce5a455a4c170e20e5bb41f9a4541dc47ca27"
    sha256 cellar: :any_skip_relocation, ventura:        "36e98005281874b8a396b799357be9631e3a698e433fbe26ff4812711ae487a5"
    sha256 cellar: :any_skip_relocation, monterey:       "36e98005281874b8a396b799357be9631e3a698e433fbe26ff4812711ae487a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "36e98005281874b8a396b799357be9631e3a698e433fbe26ff4812711ae487a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00f801dcd347b92d24d6f2dca281b464e6c627d62003dacf6d74a9595c2c4a0d"
  end

  depends_on "bash"
  depends_on "dialog"
  depends_on "gawk"

  skip_clean "etc/backup.d"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "BASH=#{Formula["bash"].opt_bin}/bash"
    system "make", "install", "SED=sed"
  end

  def post_install
    (var/"log").mkpath
  end

  test do
    assert_match "root", shell_output("#{sbin}/backupninja -h", 3)
  end
end
