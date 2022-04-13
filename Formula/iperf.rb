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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53d064f8c6a0c9e27cc39ffaadeaf031f73947482f7661dacfbb0e8d3464654e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "068287059fca2635e156457ab415db71e394bfcdc3f9534b4e1b98eae81bc6c3"
    sha256 cellar: :any_skip_relocation, monterey:       "d7b7e3999ac8c8d61a761c83498fabb78f71e8c13a096590b04e7e77bd3bf301"
    sha256 cellar: :any_skip_relocation, big_sur:        "935ca8e70d173d20c6903cd47944bd3017efeea823e2131898fce668cb4f2d78"
    sha256 cellar: :any_skip_relocation, catalina:       "4e76ef843f085b2b4fe4dc08b2163dae1139337d1fe6f529a61e7e0140008924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ec5fc2253827e7140e99d1c1e5cba088be352d913b25557ff02d0598a4c4ce1"
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
