class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.11.tar.gz"
  sha256 "39de529ae0283416acb5477197ece17ea05b81f467bec5a6ac73cbad7dd536a8"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d4888684125aa43714156d599ddd061d20fcbfa027f72e6479afa4a085691482"
    sha256 cellar: :any,                 arm64_sonoma:  "bbdc80b5907f4e816fdfaa9bbde558d8a1c856faa418f1fdc9355b663b991722"
    sha256 cellar: :any,                 arm64_ventura: "ffb8539e79521b812d1a94384f263830504d3c827c62722ed6cdd35e71945e75"
    sha256 cellar: :any,                 sonoma:        "758aeb4f8c7fcb758fd420adabe7409855b3e84d608b642dd3688bf1fdfc6e8b"
    sha256 cellar: :any,                 ventura:       "ab6cda8a35f888183dea8b4659d178a22c2b83b90210bf49e34681c55d47e335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8a19ee9d1230fd4a650f69f163e5271a1d19e71b17a5e148a0340e4197add8f"
  end

  keg_only :versioned_formula

  # https://www.haproxy.org/
  # https://endoflife.date/haproxy
  disable! date: "2028-04-01", because: :unmaintained

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
