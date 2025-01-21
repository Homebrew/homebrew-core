class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.18.tar.gz"
  sha256 "c0618175514331e766522500e20c94bfb293b4424eb27d7207fb427b88d20bab"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.es.net/pub/iperf/"
    regex(/href=.*?iperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "afa3ad80146f97f3881e7b11001b86607a2fd3f91d7b7321d1dd23e407165ff5"
    sha256 cellar: :any,                 arm64_sonoma:  "18879823e7b5da6f272ccfee521d5e472991446ac9abf02c83f4bca98815c503"
    sha256 cellar: :any,                 arm64_ventura: "fddee79c5fb5d0507590f1750140936cef0123c5880422e62cf091f28426d219"
    sha256 cellar: :any,                 sonoma:        "14cac44b69e7d492cc3057c11deca0cde4a0c7685fec6fc8d76f0c36480e92ee"
    sha256 cellar: :any,                 ventura:       "95973254270c226cba64aeb3394534de4a6c4e3c6ac5d93a221da58128bae2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e882398a3b0d2b0a2e068f0c92e76b3e4c7698c7e1e592d310b568fece389866"
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
