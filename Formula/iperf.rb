class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://sourceforge.net/projects/iperf2/"
  url "https://downloads.sourceforge.net/project/iperf2/iperf-2.0.13.tar.gz"
  sha256 "c88adec966096a81136dda91b4bd19c27aae06df4d45a7f547a8e50d723778ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b9b36d65f113055e86b158f62daa64bf5c177e27abec34c51cbb60bf2a7d4d7" => :catalina
    sha256 "8c24a0392dcda9d134c1d1121671875da4b67905321eb6e67053d6e965f92bee" => :mojave
    sha256 "7cee5824d4c70a302b3830eaf6615f52e5a1b41fdcbfbcabb46c5dd3ee00ec2c" => :high_sierra
    sha256 "4b29283a8f69c773d307501a5f89af2a0f5804ce62874b7bd2e6ea89145cf73a" => :sierra
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
