class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.21.tar.gz"
  sha256 "656e4405ebd620121de7ceca3eaf43a88f79ea1b857d041a6a0b1314801acdd8"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.es.net/pub/iperf/"
    regex(/href=.*?iperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "faf851fbea9c2a60d2c15a6dfa8d7a040084b886fa1e68caa6f59d51e0242471"
    sha256 cellar: :any,                 arm64_sequoia: "cf21e3a0261d13279ff1be54f3875d3f005d266e8148a1d0e42e6b54a024ea39"
    sha256 cellar: :any,                 arm64_sonoma:  "096c1c7ab82adc94e86f22c0a1237ced17cc6fe3488a575229d58f65dd21a3f2"
    sha256 cellar: :any,                 sonoma:        "6d3e55b3f30523a32bd346378c3692269ee59aa1c0747a1c68445f167ca7c93a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b199341bf7cb3caa6229e077980e57ade60851de489c34470e0c56535b43a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "306ca27c214fa39d10756e3d0802ea2912e2636ac6bf454aa00f0cdfc9fff8c7"
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
