class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.0/src/haproxy-3.0.5.tar.gz"
  sha256 "ae38221e85aeba038a725efbef5bfe5e76671ba7959e5eb74c39fd079e5d002e"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e7b89c31eac79d2158916951be9d2b1ea55a5b7fca838c260b371ea05fc6dc34"
    sha256 cellar: :any,                 arm64_sonoma:  "b769af010cf8f7fb60c94b3df76b56512421caa4b6878086cf17791901732d1f"
    sha256 cellar: :any,                 arm64_ventura: "56f4106b93d748767182a4d139edf7280891df7611502a19e14d6ecd547687ae"
    sha256 cellar: :any,                 sonoma:        "4646ed571a5629661650ae7dee01b6be1594cccb74df90f9bf912f79b295ef46"
    sha256 cellar: :any,                 ventura:       "37134f743fc0d3d61f44ddac244c3497cedc0f8fb4c26e223a08aab0932ac2f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2201f9e3ae0a1c7754a1c6d60b76bb885c26386e44dd601a9f4bbd81d1029a8d"
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
