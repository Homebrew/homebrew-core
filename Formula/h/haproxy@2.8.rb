class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.26.tar.gz"
  sha256 "88c28dae25ea46672e66f8db0dadd1fb5920e06ee2415ceb9f281c256b537727"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "78e1e20774a3513201e6297da3e3dcafdfaf75d92ecdad0c501a3abe8807295f"
    sha256 cellar: :any, arm64_sequoia: "6edb0d5fd2df20fabcfb6f4bb2e490cb7c9d66ab991c83fcac3570b3d22ccb87"
    sha256 cellar: :any, arm64_sonoma:  "c9f17fbaab16625b0ee5f46dad8fbb81c3c982c14d641dbf0d7b395418bb68d5"
    sha256 cellar: :any, sonoma:        "d6f5acb6555caf532c5dd120a8e53de10b63bfaa9b895ee1340fe70bdd475a6d"
    sha256 cellar: :any, arm64_linux:   "5388a0faf6eefa1ab0073179805888c71c226a7edcddb5f57f6ddc64cebc15ea"
    sha256 cellar: :any, x86_64_linux:  "84dd54d22dc80eebe99ffbaeb73a3ae9e849ba66488df751cce2d05fe8e8ba83"
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
