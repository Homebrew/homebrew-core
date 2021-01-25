class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.29.tar.gz"
  sha256 "c414be98a48d9f279460b325dddaef8479132a1470c6f305790d79e04dac1297"
  license "GPL-3.0-only"

  bottle do
    cellar :any
    sha256 "6de77638b77e9b826cd2085147a5c312156d578f3376f2e0cc3397be9a48e7bd" => :big_sur
    sha256 "8e7ccb9e8da1c79916eec5b77c2c55141bd13943d022ffee7cdbf13ee1e9640f" => :catalina
    sha256 "4b59d7b9b41bcd5ee77ca8dc5ecb00c4ba158910dc30c2083c5e4dee6b994e1d" => :mojave
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libnetfilter-queue"
  end

  def install
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
    assert_match "Operation not permitted", shell_output("#{bin}/bettercap 2>&1", 1)
  end
end
