class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.5/src/haproxy-2.5.5.tar.gz"
  sha256 "063c4845cdb2d76f292ef44d9c0117a853d8d10ae5d9615b406b14a4d74fe4b9"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "354555a4a92e89f0767a96c1731e3935cb2e971f210e06909ee1eca418085795"
    sha256 cellar: :any,                 arm64_big_sur:  "09e23f788ce706e77d1f6911b6942bcec6eee45f698baa7f76efdcf04e532ae0"
    sha256 cellar: :any,                 monterey:       "329f217f5b39cd9835f68e1612bad5c2d45b1b39f7fa3bf391e482897ec16f16"
    sha256 cellar: :any,                 big_sur:        "8ccb474ac6054d815632276dcd1511fa5bef29cca9ed2fb79e55c6832b73fdc4"
    sha256 cellar: :any,                 catalina:       "e833979c59e749a2ccd7d483839ac2f06f0e7deabce64d237e2799ad1a9e71b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16805002bd9c9af4bc4b843e4436cc107f00330c4a7a7395c7dfb2685f0026c0"
  end

  depends_on "openssl@1.1"
  depends_on "pcre2"

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
