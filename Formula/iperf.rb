class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://sourceforge.net/projects/iperf2/"
  url "https://downloads.sourceforge.net/project/iperf2/iperf-2.1.7.tar.gz"
  sha256 "1aba2e1d7aa43641ef841951ed88e16cffba898460e0c51e6b2806f3ff20e9d4"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/iperf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1515e76ee5871013496697add5d40ee8b080083cbf021f77be6f205738b095a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40befdbb1c830f1968b956c57ea6fa1ad2583cf2ba3b9504663da6ad1a5e43e6"
    sha256 cellar: :any_skip_relocation, monterey:       "770cfb03124e6b4f9e12c30e593ffed8fa3b0b80e76893455256d863d255e417"
    sha256 cellar: :any_skip_relocation, big_sur:        "963cd5836ada12db6f996d21a74662de33a978855fa02a017b129740dd222942"
    sha256 cellar: :any_skip_relocation, catalina:       "3dcfebdc27fd6572518154f7ce55243f7f6b40cb1b4d89785e0606496eb6ad0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b943de1f9fef01d95fe3ca2458898d0277777f8683f1e5d3ac43f70bf8ce113d"
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
