class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.19.tar.gz"
  sha256 "040161da1555ec7411a9d81191049830ef37717d429a94ee6cf0842618e0e29c"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.es.net/pub/iperf/"
    regex(/href=.*?iperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "67c8b3abe55fe23d1e7ac6e8eb300f57e2338a1f963f1f05e750dbe1639394a1"
    sha256 cellar: :any,                 arm64_sonoma:  "6ff5765168f49508d74b9af9ba058a936271bd458f8adb9b4e4f82c799a4ed0f"
    sha256 cellar: :any,                 arm64_ventura: "e2ca4956b1216a01c629a34ceeb0b04abf8f23436570cb92e4e15b8b5bd770b6"
    sha256 cellar: :any,                 sonoma:        "70d619e4baa2ce45a00053bdc0c1b78602567c4f306b03a21a2543b546831e73"
    sha256 cellar: :any,                 ventura:       "73a51854a8945d6eea4e9f6e92961aadce4c924debafb9feaad6c34482092941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f49105b887dd27f568736932509678e809300645a8bd2f411d91aee177f34333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bccb97178d72534912f3bff8205d1464bbfd2a3cd5f83e454cba212b59fb124"
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
    system "./configure", "--disable-silent-rules",
                          "--disable-profiling",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          *std_configure_args
    system "make", "clean" # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    port = free_port
    pid = spawn bin/"iperf3", "--server", "--port", port.to_s
    sleep 1
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    assert_match "Bitrate", shell_output("#{bin}/iperf3 --client 127.0.0.1 --port #{port} --time 1")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
