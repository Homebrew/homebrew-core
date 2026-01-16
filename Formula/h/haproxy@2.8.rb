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
    sha256 cellar: :any,                 arm64_tahoe:   "5fcfdc6473a2ef25de2570d6d390bb35643e3c2f72993a40af7548bd10d3cc24"
    sha256 cellar: :any,                 arm64_sequoia: "82ef110e2095a35eb6260f12e1df7cb314cf3d689b8978cf8b3e716f1ac7d368"
    sha256 cellar: :any,                 arm64_sonoma:  "24d52a0296309be0265f6d430eeedc39c88d4a61beffed5db672abd085af5dee"
    sha256 cellar: :any,                 sonoma:        "4636477992035514173641fa9411c64e6f0ab5abbea3ffd2e9e9e4233af3451e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8507a40a3a8f9f6dc5f277bf5ed834c5eacf291ac3aafbefb6f2e18899c0b393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78e225ca543575868f20d0a00f15b8fdc21c211448a4bb6f761fc3e990facc20"
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
