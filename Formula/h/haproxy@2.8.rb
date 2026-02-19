class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.18.tar.gz"
  sha256 "5664a435f3e5f8c22bd97adc219de6a6e73aa6be68b8d17d7324286112cf88cf"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "afcc5908496e7dcb257de03005706443d7f3a29689aca9ab82c9493fa28ec1b9"
    sha256 cellar: :any,                 arm64_sequoia: "3fa0d4bd52949a7ccd087076d59a8bb22c1e06162e909784317ca7aa5926009b"
    sha256 cellar: :any,                 arm64_sonoma:  "ee139115ef171b97e2c589bfed0f98843b3d0971e06db3533ef207b9d0f86ece"
    sha256 cellar: :any,                 sonoma:        "b200a4976e3c69559bf6010d7989a90f84f68aceb2179624c65325f5e7e298b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dc89f58a8e394316e7f789e2a4223d96507d9f7cf6fc57f08854ab39811825f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "157e26972de1d2aae8c00e01085066d033dffdc375fdabf38867b749374652ed"
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
