class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://sourceforge.net/projects/iperf2/"
  url "https://downloads.sourceforge.net/project/iperf2/iperf-2.1.4.tar.gz"
  sha256 "062b392e87b8e227aca74fef0a99b04fe0382d4518957041b508a56885b4d4f9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/iperf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "812372e578bb83c3eb62ecb76cfd87c839207e9411de51ea496ac2bb09523827"
    sha256 cellar: :any_skip_relocation, big_sur:       "16d9f9d50980aacc22fac001af878095e3efbaf582a04f52da93167473cab36c"
    sha256 cellar: :any_skip_relocation, catalina:      "9fb7611a6dc048ab405a7c106aaec36706d23d0a7b6f355efbdc668fab35eb4f"
    sha256 cellar: :any_skip_relocation, mojave:        "b2dd31430255e3759cec63173a58f5dbad1289c7c95358ed4c11d25e4ef52d1b"
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
