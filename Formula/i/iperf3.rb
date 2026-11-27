class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.22.1.tar.gz"
  sha256 "de018b5252e2a7068c89fac8b35a295d83334f2b7814aa9532a2a8107b04a4a9"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.es.net/pub/iperf/"
    regex(/href=.*?iperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "1e864a430ce0edb3f0dcc76a2b06ce9ae3fe9f3ff3f514fd510466df558c997e"
    sha256 cellar: :any, arm64_golden_gate: "c2e60cf6ae2701590d8599782e0d24c0b15942cafce31566ef84b6a0b0e97ac0"
    sha256 cellar: :any, arm64_tahoe:       "5595f27cfd5e37aa86ee2bad61cdeb740f0b4d855522c0629bbd5f296bd259fd"
    sha256 cellar: :any, arm64_sequoia:     "4634f55a2b2cf94837ca31da3c7cdced30988bbc46dfef423123c4aa1f069cd4"
    sha256 cellar: :any, arm64_linux:       "4387d45f6479d4f8fa60af93e1f0981f689e82e74a9cacb1063fc80188db7a04"
    sha256 cellar: :any, x86_64_linux:      "b0c53c497787f5373d3b3ed8bbcbc804715498ff0c82f3d81ac40d4b5f579027"
  end

  head do
    url "https://github.com/esnet/iperf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@4"

  allow_network_access! :test

  def install
    system "./bootstrap.sh" if build.head?
    openssl_prefix = dep("openssl").opt_prefix
    system "./configure", "--disable-silent-rules",
                          "--disable-profiling",
                          "--with-openssl=#{openssl_prefix}",
                          *std_configure_args
    system "make", "clean" # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    port = free_port
    with_test_process(bin/"iperf3", "--server", "--port", port.to_s, signal: "INT") do
      sleep 1
      assert_match "Bitrate", shell_output("#{bin}/iperf3 --client 127.0.0.1 --port #{port} --time 1")
    end
  end
end
