class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.2/src/haproxy-3.2.0.tar.gz"
  sha256 "f762ae31bca1b51feb89e4395e36e17f867c25372a10853c70d292c3dd17b7b0"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0cd4a609d905d8e40b7bd9b457d1186a17ba96b0b34f6a35082bd61dc704dca"
    sha256 cellar: :any,                 arm64_sonoma:  "5aad263ffbbe3350a043448866e2fee5a73029677575f47d746f1ff8af491ee2"
    sha256 cellar: :any,                 arm64_ventura: "f0f908c53fe41c3de730e781abf46f6d5ae52c85943c5a8ea88f207dc21196f7"
    sha256 cellar: :any,                 sonoma:        "58e8009926d3a5b9d22e217751fbb1249d2c2fb855af86e9a4c17182fa433caf"
    sha256 cellar: :any,                 ventura:       "7e0749351bc210f25390c0bb7c33f908b32eb3e7b5be2312391e54774fbd31f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7d3e2313c834b90fc62689b39511112ab02e300b566c111c64bdf9a0b441253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0466fce7936443207e4925ab1aa1f9d29ee150577d81b884ce3fff1bf9c19da8"
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
