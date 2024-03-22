class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://sourceforge.net/projects/iperf2/"
  url "https://downloads.sourceforge.net/project/iperf2/iperf-2.1.9.tar.gz"
  sha256 "5c0771aab00ef14520013aef01675977816e23bb8f5d9fde016f90eb2f1be788"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/iperf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c215111f712f06bfc8d4e2b59df2647fc627aee38e402169e1a4619f216bdd1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1ea30486e89e978722b854f72a591f197419d6c529b2cf1bd2164010698c0cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "255b5d8f43b5d0de1819d006d6d2e929874c4020243e0bac75132404a7bcb617"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d55ff3cae4a261695736b7065c5a0b06988b35d11f806b48cd5b6da1ab62344"
    sha256 cellar: :any_skip_relocation, sonoma:         "01a6ab19370c9b73e6e6de2d73439332c86d693dddbf29b759cfd9009db6bf8a"
    sha256 cellar: :any_skip_relocation, ventura:        "ebc74e656e2733dc621629cf9a986a0f615a3b68061fe7dfcca74f7d969e1676"
    sha256 cellar: :any_skip_relocation, monterey:       "dffa26177ca409e576636726281d6f84a80896aaec1e4987841a6e31703978ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "f810f2117e5bb272d2640627f96481d12fef85d9c444e7ca789feab89eb0fed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72ec63f092aa146d76d83edefc618f0bae97f78b03cda0c3c6d21c4ada52b648"
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
