class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.15.tar.gz"
  sha256 "bdb77c11f72bce90214883159577fa24412013e62b2083cf5f54391d79b1d8ff"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.es.net/pub/iperf/"
    regex(/href=.*?iperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "39860d07e3b77ae4e8973398df2b291f60c82323485f208ec132e77f50f9f578"
    sha256 cellar: :any,                 arm64_ventura:  "f234c075a47f5331757dd3be027fafde8507d46562f9b186ef585ff3aade37aa"
    sha256 cellar: :any,                 arm64_monterey: "ac6c6f3c2c5c62a63244c15ea98f3aa1b1c061c33fdb662a8f9353c5607bb4ce"
    sha256 cellar: :any,                 arm64_big_sur:  "08a117ef85239a2b485a64d8cbd2a835821ce9c714eb590ff533dbf70bf1c2ec"
    sha256 cellar: :any,                 sonoma:         "ef830212e24f6b170d83ed8439da60fcfac6bba694de1589944c6c3a41d2b15c"
    sha256 cellar: :any,                 ventura:        "90de2b3c476f7986687ced87584606ad6afba8474862a764f9faeb537c06689c"
    sha256 cellar: :any,                 monterey:       "136dc4017063a7bc9a6c0a5044c9a12fe8704e96ef0470d3cfc80fda6838b82d"
    sha256 cellar: :any,                 big_sur:        "423503cb3b0bd1d4f410ceda13a61369e885f7b2bca83bbd005a631b3f074467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91e646e0748c494e17dbd40f14a2a42609c730afa6a333a37a99b8e4c122f61a"
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
