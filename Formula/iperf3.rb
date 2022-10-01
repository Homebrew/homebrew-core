class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.12.tar.gz"
  sha256 "e38e0a97b30a97b4355da93467160a20dea10932f6c17473774802e03d61d4a7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "07f43ee08140b9ed415ef4c84d58f0a0242ca4eb11bd5d9691e55066e341dbfd"
    sha256 cellar: :any,                 arm64_big_sur:  "516f56b84472047a2ba899046ba1e71863ade4f4fb6cc0838ab863b576bc8157"
    sha256 cellar: :any,                 monterey:       "3d6733f84c93d152e2ea210b3797a789e056b12f0a67ea8a615eb72c9eedac8e"
    sha256 cellar: :any,                 big_sur:        "b23050ed3f6e8fd6cf43597446fd172b612a2ab539c1b71210ad45182563fb3c"
    sha256 cellar: :any,                 catalina:       "b3d74087ec104d3b95e491257d647a3e665ed3f5ff63ba176fc4d3d27e253f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3d05c024cb3e1a062734db9bff61758385b9058aefb896330c9136f37754aff"
  end

  head do
    url "https://github.com/esnet/iperf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-profiling",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "clean" # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    server = IO.popen("#{bin}/iperf3 --server")
    sleep 1
    assert_match "Bitrate", pipe_output("#{bin}/iperf3 --client 127.0.0.1 --time 1")
  ensure
    Process.kill("SIGINT", server.pid)
    Process.wait(server.pid)
  end
end
