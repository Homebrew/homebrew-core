class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.4/src/haproxy-3.4.3.tar.gz"
  sha256 "7fa666d36d198275999e2a68dda44d3d37960f2f7aed3a595fb811f4fd0515b5"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3c65ed8dfa6649c2b2df8c285d56b6e5ee88bebb908f4c5f7e2fd6d737f634e2"
    sha256 cellar: :any, arm64_sequoia: "c151069d87d76fb379cc9558d896447214cf3564ee23d1570667b6c84a480f39"
    sha256 cellar: :any, arm64_sonoma:  "62ed93f6d9f482adede403f0d2410532906ae3dce4f650845100c102a962c07e"
    sha256 cellar: :any, sonoma:        "55fd5fc92334caa681179d83449c47dc586d13c9dbcf0b7ebbe9e60a06889c4a"
    sha256 cellar: :any, arm64_linux:   "aa444201ce847cd28cb98cdb91c288fb8de0ffd7f056a5b18e0cb944e0f098cd"
    sha256 cellar: :any, x86_64_linux:  "c90347ce67e43fc4d5a66173601773c93cc2ce3ba97754e009f37ef988dfb4e9"
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
