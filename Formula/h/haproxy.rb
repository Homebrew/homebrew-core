class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.0.tar.gz"
  sha256 "bf2da6b69f82d7b855be977ab9e1d4704eef5629b657ac72afb5958a869c902e"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57c8b7c297a75f053fee7bfae0a08eac39be046af1c98d646ff554410d8237d0"
    sha256 cellar: :any,                 arm64_sequoia: "5123d6c0e270c0bbaace099df613d2b69e0dfda1163547653585079a41f4fcc7"
    sha256 cellar: :any,                 arm64_sonoma:  "dc765a80f47cd8e43942cf7322267584506f078c1087c6c1cf692c2819a91193"
    sha256 cellar: :any,                 sonoma:        "2b18b051806d76c4b2c48b1295dd847e2dafcd39a2758bd1bbb65ac5677fe1f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12b6ec60d350fa83bba4a5a67296a15fb931c91cf52dfdc86243d0d8c143ff71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad484d015fc31dcde3c5a3aab53b0fc7a285a3b55be1dcf844c0f62d708231b"
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
