class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.19.1.tar.gz"
  sha256 "dc63f89ec581ea99f8b558d8eb35109de06383010db5a1906c208a562ba0c270"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.es.net/pub/iperf/"
    regex(/href=.*?iperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1630fdd41b9e363e70fdfa0390dac4dd1c884375acf19ddf227abbf7bb7002ee"
    sha256 cellar: :any,                 arm64_sequoia: "77ccdb114a4c79a0649bc2d0a660bf884d2b4f4372e8944021aeb10f5e9faf37"
    sha256 cellar: :any,                 arm64_sonoma:  "6f73dfb6118ea93da67d23d2394d4cadca552e97a9ae3cbae39f4d6b0d7b350a"
    sha256 cellar: :any,                 arm64_ventura: "f4bbf1679667d2cdd9cc15246b0df44b7b25c21e94d93b80e1a27b008cfb194c"
    sha256 cellar: :any,                 sonoma:        "54df2f7e284458c0d81a9208ba39c5d30d7c8ecc0d5031ab6567c7521ec3aee5"
    sha256 cellar: :any,                 ventura:       "0415f5939d7d427618b739cfcdf006cb936232756b4acf34e4bbca64c543b4d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1b01736e25f06ebd563d0c45611e37d6f0d41012daf37f23642e80900dcb30c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d08e72ccd5ffb3a3bab60e65fd54308eb6dc6ddf8703fadae1341b88b77faed"
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
