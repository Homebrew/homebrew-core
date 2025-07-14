class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.2/src/haproxy-3.2.3.tar.gz"
  sha256 "af8ef64286bdddc93232c5dbe4ea436a8ccb5dc8417cfa1e885bec52884f9347"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ee2d0176557295c48cd4fc36682491bfd974cde5adc9f940be83fc38700fdb7a"
    sha256 cellar: :any,                 arm64_sonoma:  "91824951aeae7ea7b80e78fa1763aa6b5a1f29f3201e9cfb9eeef0d60af6c488"
    sha256 cellar: :any,                 arm64_ventura: "feb12f52bd2579644b2fd3c8cafc964c18cf40753949029f48933c991b5e6876"
    sha256 cellar: :any,                 sonoma:        "dbf39f846b64fe45a2b64d565b725b84706260242b72efa744abe834db6e39c5"
    sha256 cellar: :any,                 ventura:       "ddc6266e3197860ade8d7de1a95edc2c1666a4662abe005ff55c23ddc2332f7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2c32849c78f181f13cddc807ada2492974390b343d836a1025ded0f81524099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d5fb223e10909b219d404e9ab3a6cc26380c62dde53113b042b7fe88be59c68"
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
