class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.16.tar.gz"
  sha256 "cc740c6bbea104398cc3e466befc515a25896ec85e44a662d5f4a767b9cf713e"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.es.net/pub/iperf/"
    regex(/href=.*?iperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "71914e21e7b6e80559355dc49a338e1387eb44ea649d823b952e2203dd2d20e5"
    sha256 cellar: :any,                 arm64_ventura:  "2a1ad6171b0e29f4af56b9219ad78b77f04cf90a38786e69ed297c972aeab95b"
    sha256 cellar: :any,                 arm64_monterey: "9d73c5d0327198790d8a3c295bdca4e610c42a9bf88a4445f5536fc8c78f3780"
    sha256 cellar: :any,                 sonoma:         "bb9f51c9733c6da87b372a150d6cf141b1a36e0e49325400e81f0da1824cbdfe"
    sha256 cellar: :any,                 ventura:        "06897a191167869e24516794343132bb958a449b959b8194ecc2156c4cd8426c"
    sha256 cellar: :any,                 monterey:       "bbc01fe8e1e7b8822d71ad9217dbf851e72f1f02ebbb3899a29e04af13e3aad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "639920f791fff7e020fbe06f2a8f216c7334c543d54c82cd8bf6a25cf217b217"
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
