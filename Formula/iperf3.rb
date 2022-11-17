class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.12.tar.gz"
  sha256 "72034ecfb6a7d6d67e384e19fb6efff3236ca4f7ed4c518d7db649c447e1ffd6"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "c8ed6e824689e69c4c0d2eec8a80fb54d901769429fcd84b9598e434d55c8b35"
    sha256 cellar: :any,                 arm64_monterey: "9207226775b4889c2bcc0c0144b46b69f400048c62123ab4bdc0c8132bed79b0"
    sha256 cellar: :any,                 arm64_big_sur:  "a9771e4a890b5b56a184a90cc1bfb8b7549e95d412d732a64a5327f5b52fad2f"
    sha256 cellar: :any,                 ventura:        "a11782c6c7a69127bf09fa58de6480bd4add5af8842dca9c98be2ecf5f87f6dd"
    sha256 cellar: :any,                 monterey:       "21aafa39e3e3cb2cb7aa7cb19f8d720f12bb65a80994ae38f477e4f22664dff6"
    sha256 cellar: :any,                 big_sur:        "f8c46352bf2b270fc4bb61035c05f04edfc96a2bb2fdeea0c36f38d5311f41f2"
    sha256 cellar: :any,                 catalina:       "89e90520f268578ece5cf6c2f3a39dc7e54830e02f4996b22447c015ef4d821f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c20145292980f9529b8637aac27300a8359967a53c1a85c5fb3c2e8c03a2c77"
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
