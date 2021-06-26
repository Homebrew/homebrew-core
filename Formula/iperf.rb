class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://sourceforge.net/projects/iperf2/"
  url "https://downloads.sourceforge.net/project/iperf2/iperf-2.1.2.tar.gz"
  sha256 "10a117ff33807b455187349e8b05aaf4d17e9a50c6cf46fdda5054e849a9ecfe"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/iperf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7718be6a70d76b120eb4e8891a79e727053ec366f4cdf710ff4d8960a22c62f6"
    sha256 cellar: :any_skip_relocation, big_sur:       "9cc3f80f4761d70123eb53b490f7922a6373675d4abc4417b0c576433fcfd4d2"
    sha256 cellar: :any_skip_relocation, catalina:      "0b9b36d65f113055e86b158f62daa64bf5c177e27abec34c51cbb60bf2a7d4d7"
    sha256 cellar: :any_skip_relocation, mojave:        "8c24a0392dcda9d134c1d1121671875da4b67905321eb6e67053d6e965f92bee"
    sha256 cellar: :any_skip_relocation, high_sierra:   "7cee5824d4c70a302b3830eaf6615f52e5a1b41fdcbfbcabb46c5dd3ee00ec2c"
    sha256 cellar: :any_skip_relocation, sierra:        "4b29283a8f69c773d307501a5f89af2a0f5804ce62874b7bd2e6ea89145cf73a"
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
