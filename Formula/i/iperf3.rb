class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.14.tar.gz"
  sha256 "723fcc430a027bc6952628fa2a3ac77584a1d0bd328275e573fc9b206c155004"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.es.net/pub/iperf/"
    regex(/href=.*?iperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ab0fc5615e81c6df60ef9b38870e6a7089e8335a3e6c932f14ea686832b93e37"
    sha256 cellar: :any,                 arm64_monterey: "dea7d322cc59a723e275bf7f9f96931a938ddb0acdd659ee6d3f43f653609b1f"
    sha256 cellar: :any,                 arm64_big_sur:  "88227e2a989b1383774c39f28524d55b73dfb45c92c2566d0c3ac1a926a1b63d"
    sha256 cellar: :any,                 ventura:        "f48399115677cc04b11f9522c6c877492b3c35eab15318f42cc69a5a1b6939ec"
    sha256 cellar: :any,                 monterey:       "498d1ecdc91abe7802a7fb6ff224741c02daf51f5e8d3397e67c8681f80de152"
    sha256 cellar: :any,                 big_sur:        "3710c98bb3c71b2d14eee936a93904f94642b6ddd2d6cf8aba5bfb1ccc294530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29c4c3df48b332a540bfab3107e420714912f9784bdc751b32a36d1185cde999"
  end

  head do
    url "https://github.com/esnet/iperf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-profiling",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
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
