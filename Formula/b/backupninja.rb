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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9df3e07340b1c7c046d9d83009c271cb27105940e6be345a50013abcd04357b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9df3e07340b1c7c046d9d83009c271cb27105940e6be345a50013abcd04357b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9df3e07340b1c7c046d9d83009c271cb27105940e6be345a50013abcd04357b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbf31b7459787f092bd97a26c0a34998dd62552a9ffd074bae6e6701c1bc040e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1b2ff8288fc767429a63559e1c4a59bee787610a32ed320cd34d57492885f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1b2ff8288fc767429a63559e1c4a59bee787610a32ed320cd34d57492885f65"
  end

  depends_on "bash"
  depends_on "dialog"
  depends_on "gawk"

  def install
    system "./configure", "BASH=#{Formula["bash"].opt_bin}/bash",
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          *std_configure_args
    system "make", "install", "SED=sed"
    (var/"log").mkpath
  end

  test do
    assert_match "root", shell_output("#{sbin}/backupninja -h", 3)
  end
end
