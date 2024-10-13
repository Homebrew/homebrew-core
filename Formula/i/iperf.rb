class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://sourceforge.net/projects/iperf2/"
  url "https://downloads.sourceforge.net/project/iperf2/iperf-2.2.0.tar.gz"
  sha256 "16810a9575e4c6dd65e4a18ab5df3cdac6730b3c832cf080a8990f132f68364a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/iperf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5b7d862bff39bacaa05bc8998eb26dc12e5a2d40894d5e5b0a73565d32bca7a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bf46728f92fbd32daabb6a35d6ac65ed54a5285b017a4b544f9a9cefabaa5a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e49f0e744808cb351870679663cbd622597a6c9513389f8857f9461fac26f2ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39d2a630219f6ae3fe31912068260c1419feac89de34fd3944207a5f6303a820"
    sha256 cellar: :any_skip_relocation, sonoma:         "976257ee411e2898cef5af8afeb8b48b8f08d8c0f93fca4e6e515c811d7dce4b"
    sha256 cellar: :any_skip_relocation, ventura:        "1ab6d572f2c64ded3c9911dcec07dfad00e9367f26a33d6115cb51248c93edcc"
    sha256 cellar: :any_skip_relocation, monterey:       "c0984a0a8f32905a4da2262d07783338f202374d97319b8af4b0e3dea1451078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab44b170204b938a97834bf13e94375b0a07c46bd5f2fc4235effbfc6491f2f0"
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
