class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://sourceforge.net/projects/iperf2/"
  url "https://downloads.sourceforge.net/project/iperf2/iperf-2.1.3.tar.gz"
  sha256 "d3a30ce7522f0ae6afaadd9b0b4375938b0b0b48e827163148773496c91e9320"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/iperf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "203e5df71610330a6231993f1a5d4deca0b8823e2446b0d8591dc70ca15b333e"
    sha256 cellar: :any_skip_relocation, big_sur:       "51d36957db899b5874635ad613f987b6408851f25938ec7e3f1102f870c90e36"
    sha256 cellar: :any_skip_relocation, catalina:      "17d334f6f387019ece93659873fb119606bc8e2dfcaa6744619c5fe7b5578b36"
    sha256 cellar: :any_skip_relocation, mojave:        "2cea58afd7a790763636b5dca9dbf21d508db231239ae39573c37c13a70cc739"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    server = IO.popen("#{bin}/iperf --server")
    sleep 1
    assert_match "Bandwidth", pipe_output("#{bin}/iperf --client 127.0.0.1 --time 1")
  ensure
    Process.kill("SIGINT", server.pid)
    Process.wait(server.pid)
  end
end
