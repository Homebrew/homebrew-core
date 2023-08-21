class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.2.tar.gz"
  sha256 "698d6906d170946a869769964e57816ba3da3adf61ff75e89972b137f4658db0"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a97cb20ca0e17f4457ab5fa7eb55a4b9037994bf64441d3447c5065946f48447"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6beaab6a54fa4744c0e298a0b392666d78149e009459c0b4e6c46e685bc72c8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a267d74de3f786ef84f367482a7d0b65a838eb21afadbbca002ced603ee93fc4"
    sha256 cellar: :any_skip_relocation, ventura:        "dcbe21eb5e609c952030e12b24abfe525f08eed394142f6b3edd5e7224c37641"
    sha256 cellar: :any_skip_relocation, monterey:       "d01294ece14f053d1bce9f82f527f03e2d3faeb6d7d7a6e597ee9012b5f408bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc5a4cb7a5f14b6d4c75d24abaacdafe06b99bc622df4084caafb2390c4d492c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d52ea2ae9fac94566471be964c4c8b293cc909795e8cf82e7a8be9de939d1ba"
  end

  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    args = %w[
      USE_PCRE2=1
      USE_PCRE2_JIT=1
      USE_OPENSSL=1
      USE_ZLIB=1
    ]

    target = if OS.mac?
      "osx"
    else
      "linux-glibc"
    end
    args << "TARGET=#{target}"

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  service do
    run [opt_bin/"haproxy", "-f", etc/"haproxy.cfg"]
    keep_alive true
    log_path var/"log/haproxy.log"
    error_log_path var/"log/haproxy.log"
  end

  test do
    system bin/"haproxy", "-v"
  end
end
