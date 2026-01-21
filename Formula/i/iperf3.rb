class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.20.tar.gz"
  sha256 "3acc572d1ecca4e0b20359c7bf0132ddc80d982efeee20c86f6726a9a6094388"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.es.net/pub/iperf/"
    regex(/href=.*?iperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21d104a64ab9a03149a6a68621fe7c34113107d7c241aae10b30f7f54fc63278"
    sha256 cellar: :any,                 arm64_sequoia: "da658d9fe13ab8492eb7a6b73312990099c6a9da7a91c97653c977e183f1afce"
    sha256 cellar: :any,                 arm64_sonoma:  "df35cee97da6db01620d52d7ca55c882fa7282add347822150412e23037877cd"
    sha256 cellar: :any,                 sonoma:        "7b8079f6dc2f72de7a70d62aec60312220fe395646f9b6d1307d9e8fafd82ade"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0ae4a5324a6eae284b7863f6ca0d94fde6b0bc53dea043093533953a1c1bccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b2515f7071e158cb4c44bdc26a5ca183e81cb00565b4e1f2fbb7393d5cc7183"
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
