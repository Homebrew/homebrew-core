class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.33.tar.gz"
  sha256 "bb968c3b241692c448672d4c90bddb1e759cdeaf0d4eab1178c734b162fd5f48"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src/"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "a2b0055cbc216efb2fb45d527923994102727110aa1b0dfffb5036a94f20e08b"
    sha256 cellar: :any, arm64_golden_gate: "a358b9f9058ebf22be89d50b64a3863e75e6b446bc886187a3ecb096d9468b9a"
    sha256 cellar: :any, arm64_tahoe:       "254cd5c4a7301675c1c426bb20d6bf11e3ab8e94bb98eec9bd95d62da245d3a2"
    sha256 cellar: :any, arm64_sequoia:     "c603e7e6bf162c2da2342cb1b177668d3805a5e76929257786cba3d78dadceeb"
    sha256 cellar: :any, arm64_linux:       "a28e848f91525cda2b267bceba28362db1048d15200bee6f07a39bf6bfb8b207"
    sha256 cellar: :any, x86_64_linux:      "188f5f7d3d825b813d619112563c026d1ae165d2922e9ecd740505438169ad47"
  end

  keg_only :versioned_formula

  # https://www.haproxy.org/
  # https://endoflife.date/haproxy
  disable! date: "2028-04-01", because: :unmaintained

  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
