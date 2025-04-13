class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.1/src/haproxy-3.1.6.tar.gz"
  sha256 "21852e4a374bb8d9b3dda5dc834afe6557f422d7029f4fe3eac3c305f5124760"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c8ce69b9dd8a7cf69cb1b2356ca25306554670183f4f6db031d5ea11f0d763a5"
    sha256 cellar: :any,                 arm64_sonoma:  "5a41a6a01db1fc241bf88030de19e244d613c85f036c401c129639683ff71d4f"
    sha256 cellar: :any,                 arm64_ventura: "c578f88f5caa438de2bb04d6ac1c911798d4557df7edaa074c67355c83592912"
    sha256 cellar: :any,                 sonoma:        "6d227b5cf8a24e59a64fc9616de77dc8f12205427ed2c42222f3a3c9ce24d28c"
    sha256 cellar: :any,                 ventura:       "91c57790699fb4c5ac708440a8e4d28c439aeeb4020bb942ce75d616d305025c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "736bfe0971367dc6e0859db4870d969f8486683d0e26e3130222b271cfa10954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b03a66f0ac1d99efd6453189a3f93e9d20e543e0312b9780a488d5cf09c92ae1"
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
