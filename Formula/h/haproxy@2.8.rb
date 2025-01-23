class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.13.tar.gz"
  sha256 "13dc06a65b7705b94c843bda8b845edbb621bf45e8a9dc7db590d40ab920a9ce"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "179deac9d37170f3faf8472478e1cdd65454d3101c5ba188549b95c3c67a8dd6"
    sha256 cellar: :any,                 arm64_sonoma:  "7fcf8f9e7be73e30f1ec085e1c766b728efe88c5b2981c24702800502cf0577d"
    sha256 cellar: :any,                 arm64_ventura: "ec11059bf9914ebaccc0e56910d93f65aeccde6714489ba00ebd2985ef69eb81"
    sha256 cellar: :any,                 sonoma:        "7189d299c70b5740183b736741251d4d1a21feea86a554cd3a68a9f2b8038456"
    sha256 cellar: :any,                 ventura:       "6e181c27239c3373fc8e9a54f544ac1cbfcb2ca4278034093b1bf8aa54114ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a416b844daa2c445773571c46d6aecdf4473b5c80be66dd097bedc7320b6758e"
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
