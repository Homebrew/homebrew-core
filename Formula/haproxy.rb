class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.5/src/haproxy-2.5.2.tar.gz"
  sha256 "2de3424fd7452be1c1c13d5e0994061285055c57046b1cb3c220d67611d0da7e"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "770722438ba273d7e8e1d610a2a7d3d0e090110b2ac241d649cc3a1bf04327ce"
    sha256 cellar: :any,                 arm64_big_sur:  "a5f92ce5463c411e0ac5aeaf6f79ec3a26fa6e8f716c1accc8613afdd47225e6"
    sha256 cellar: :any,                 monterey:       "a533781b3b0af7d0a846679cf9516102745a56d7ed4e74877f0d4a1f774c16ee"
    sha256 cellar: :any,                 big_sur:        "931107be686a5d95006313dd3812333ac7ddeaea5524477275ca27528dd75324"
    sha256 cellar: :any,                 catalina:       "a8d9185b7bafb54b199fa73f497342f91a2bf87aa3f0405d04b90dede6be944c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfe0e2a986df10ce48a43ec8c13451bf45800def3a5993707dce3842866a534f"
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
