class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.21.tar.gz"
  sha256 "656e4405ebd620121de7ceca3eaf43a88f79ea1b857d041a6a0b1314801acdd8"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://downloads.es.net/pub/iperf/"
    regex(/href=.*?iperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c9732362cf41e8564f33fca550a9a49356ea2b54bf5b1c021ac828038c6ae46"
    sha256 cellar: :any,                 arm64_sequoia: "9c2798aa7042d06364caca9fec400651d5cc5ae26446b24c308827c30649a40a"
    sha256 cellar: :any,                 arm64_sonoma:  "c63e8ff6df89f6a8f9e5bf7689d0aee545d47725f9bf9068e492b42890fdabdc"
    sha256 cellar: :any,                 sonoma:        "27a27e6ade18fc7b85803b70c08571a6a76178a7a12c27f48a4917dc5f05646a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcf35af72941dad9ecfc704500471dfb43bb5dc35bba09b47ad358acf25e6369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa5c3dae2b89ab6be2a65e6c3f90a29d4a99ef5b54254c78331d970781eb82e2"
  end

  head do
    url "https://github.com/esnet/iperf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@4"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--disable-profiling",
                          "--with-openssl=#{Formula["openssl@4"].opt_prefix}",
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
