class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://sourceforge.net/projects/iperf2/"
  url "https://downloads.sourceforge.net/project/iperf2/iperf-2.1.8.tar.gz"
  sha256 "8e2cf2fbc9d0d4d1cf9d109b1e328459f9622993dc9a4c5a7dc8a2088fb7beaf"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/iperf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed84fdcdc9fd2034bf6c32acd4821dc00e11db4512552d5c879b4bc996b09619"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40ebdb5ef396a522db73aaba0f3232b8af14c247fd5f503b39f9f3da2e90f50b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f3a7478e33428ce4f5d6fbd0b8cc2d8082b54298ccb8a71b29e60b52ff2b4b8"
    sha256 cellar: :any_skip_relocation, ventura:        "fb0b611615484521a45895e6d695e99de7db6534e3a207bd65471bb09ab6e767"
    sha256 cellar: :any_skip_relocation, monterey:       "a3a130ee28a7969fd6e6f4d8c316c55588e178cf3c2b33a337e98cf55a2812b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c039d85e7ef0e1d4f265f11ae90a68a9b4b7c992b2d0df6ecca20db96dd0c1d5"
    sha256 cellar: :any_skip_relocation, catalina:       "8f89f4022a0f9a21dc5b768e9b081c0597583fedf8d705abcfb53a42a574d705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "786e18cafe8103a4ac02fb1a318f1501911ba8a67f4e18fe439c7335721350c5"
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
