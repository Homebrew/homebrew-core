class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.4/src/haproxy-3.4.4.tar.gz"
  sha256 "b0c5053c4d46840ecdee3925736fe9a3de6472559b43c69183d70e593d9133df"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5096df1aede7f69e2759c2a1eeb89bf48870de38190800cc4e2f485f9108c544"
    sha256 cellar: :any, arm64_tahoe:       "a22c5be32a4674da61bbf13bf465d9b89a38e08e3282d5ac335cb16da1d4ad4b"
    sha256 cellar: :any, arm64_sequoia:     "5fa7462b8ea2f6d0dd9f1555a050d70fee6a2ad9ec2dec3e9ec00424aa1ecda1"
    sha256 cellar: :any, arm64_sonoma:      "1ee9c94889c0d3c00d9e1addd5d4dcdf28d1f898dd337e40c17ba6db69b0092d"
    sha256 cellar: :any, arm64_linux:       "57d656d0e364420709a64d5b399359d9d003ae16872c6660c7f6ca14bfb4580a"
    sha256 cellar: :any, x86_64_linux:      "08b9aa1e60dd2212f7fc21eda32d6f3d3c7081fc1ab9021e4db29ebe8381d58a"
  end

  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      USE_PCRE2=1
      USE_PCRE2_JIT=1
      USE_OPENSSL=1
      USE_PROMEX=1
      USE_QUIC=1
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
