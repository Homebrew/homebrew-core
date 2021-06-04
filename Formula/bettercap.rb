class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/v2.31.1.tar.gz"
  sha256 "f37ffb8c13b9f0abccb7766c4ecbf295d6219aaf4dbf141e2b71c2a1c9cdc9aa"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "63f4451b9ab250464d26d27d4358c4c0d4f5aaadecb2bbfaac1e8f4b1c411d2b"
    sha256 cellar: :any, big_sur:       "8fb85b3ad02828d25d5a8fc942ccb6cd9ac95f7fe276768060dd353b27b020ab"
    sha256 cellar: :any, catalina:      "2fc1f3339e9c4a0143de65c4cdf0a32d6d7ce17c924ac46e71cdc2bebdadd413"
    sha256 cellar: :any, mojave:        "16fa04f46a97b8919af31d58cb0815c440abb3fec255f4caca073242c05d88d8"
  end

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
