class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://downloads.es.net/pub/iperf/iperf-3.22.tar.gz"
  sha256 "1c0d0fb02c52626111d6e132db80edfbf27bbaff8bd9245df2a371dcb0b35a92"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.es.net/pub/iperf/"
    regex(/href=.*?iperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6f9b73d21926fdbb1e05ec0acc99bbcf14c4daf17646b517fe3ceb55b1782ed3"
    sha256 cellar: :any, arm64_tahoe:       "0406c80fc7addf00ff01fccf8e80c90ec224fb59950cfc0545a28b0a871bd897"
    sha256 cellar: :any, arm64_sequoia:     "4e9af1cced938a2b1b368ce3ac5fa6a69cf693926d638f93976e07d0f1618107"
    sha256 cellar: :any, arm64_linux:       "6674f6a76dee7d39e08b7ffe4f9af8caa7bd6fd8fe698b1d134546475169db5d"
    sha256 cellar: :any, x86_64_linux:      "e41796ff65e2813c6cf421fdc2915cb52dd93ec8869011d42e1fd885ff911858"
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
    system "./configure", "--disable-silent-rules",
                          "--disable-profiling",
                          "--with-openssl=#{formula_opt_prefix("openssl@4")}",
                          *std_configure_args
    system "make", "clean" # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    port = free_port
    pid = spawn bin/"iperf3", "--server", "--port", port.to_s
    sleep 1
    assert_match "Bitrate", shell_output("#{bin}/iperf3 --client 127.0.0.1 --port #{port} --time 1")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
