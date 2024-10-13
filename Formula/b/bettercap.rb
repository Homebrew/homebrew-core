class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/refs/tags/v2.40.0.tar.gz"
  sha256 "33fb079d148bdbf640a6a634873dec7799430b0e949ba45007976e50c1323000"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8b8f6447d4dbaad6f2dbb89b801807f4670777f0dc25b905924f985c629288af"
    sha256 cellar: :any,                 arm64_sonoma:  "5df2c794da75cf37a9edf38351bb405e54320d7d555b7b87b75128dbcfe08587"
    sha256 cellar: :any,                 arm64_ventura: "c5a137b63baf4aab7e8d297019618615d0fba2d5d789fa9f1bead8349f9b108a"
    sha256 cellar: :any,                 sonoma:        "dde80720f52ef5c25de0a087ff1c340419048589ffa7b61eab562089c4532ddf"
    sha256 cellar: :any,                 ventura:       "756e19d68edbd12e72b5d7a5cb14c00c703bce3550f0c1b579d934941d3163fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c81126dabeec39c55d524922f6ed05644c9e9a2198bcc71b22b669f640390ee"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libnetfilter-queue"
  end

  resource "ui" do
    url "https://github.com/bettercap/ui.git",
        revision: "6e126c470e97542d724927ba975011244127dbb1"
  end

  def install
    (buildpath/"modules/ui/ui").install resource("ui")
    system "make", "build"
    bin.install "bettercap"
  end

  def caveats
    <<~EOS
      bettercap requires root privileges so you will need to run `sudo bettercap`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    expected = if OS.mac?
      "Operation not permitted"
    else
      "Permission Denied"
    end
    assert_match expected, shell_output(bin/"bettercap 2>&1", 1)
  end
end
