class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://github.com/bettercap/bettercap/archive/refs/tags/v2.42.0.tar.gz"
  sha256 "cdcce5b68b426c286b0b6aa1aabd2c84f6e891dd3b6e441d4a61de07ccf653a3"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git", branch: "master"

  bottle do
    manifest_sha256 "0a614cffdec5e7816f61779fbb281a03af23d074261fb7dd869754c3164b024b"
    sha256 cellar: :any, arm64_golden_gate: "706483dbc0e1bbebe564de4f159812cd72f3f794a5eec4a164cd5342bda0c9a8"
    sha256 cellar: :any, arm64_tahoe:       "2d6084eb7e421172f44c9206ee938886106710b040614720c8119829b230c059"
    sha256 cellar: :any, arm64_sequoia:     "56cdb6f133975e2571e5cae18fe989a1f728a05966cf698be1e662f8113cfefd"
    sha256 cellar: :any, arm64_linux:       "0bfb044dc2d4719d3a500df194e2ac184f958f26f74fa59550c30e3d9a779b14"
    sha256 cellar: :any, x86_64_linux:      "722fcac485f99d4280b90240c647eda156a3a77fc0a66c25b4c512305cffebb1"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libnetfilter-queue"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
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
    assert_match expected, shell_output("#{bin}/bettercap 2>&1", 1)
  end
end
