class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.12.tar.gz"
  sha256 "e38e0a97b30a97b4355da93467160a20dea10932f6c17473774802e03d61d4a7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d5134c2caeafb982bba9847e5bd526c87b3c9f7497771c7c69d17698a8916d56"
    sha256 cellar: :any,                 arm64_big_sur:  "151522a09666e687025f63b8df9bd11aa6661fa7a2a8b7e4597e061bc4325034"
    sha256 cellar: :any,                 monterey:       "85f04bc7125b2c8e2271d3b028d8f5b2f06106d4006f320675fa31595894b291"
    sha256 cellar: :any,                 big_sur:        "c344dff846ad280292bfdd074e324fa291eb07d118df71c5c09d37f13e1d5ffd"
    sha256 cellar: :any,                 catalina:       "5ec5c9c380371b11077e6f3d15cb321cf40f0ba5007b3a2dbacb3204b55974e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e787012937dbfe79a67f32d36715c12d6903278cfd57fd64704fdd5157731a79"
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
