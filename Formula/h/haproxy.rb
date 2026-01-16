class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.1.tar.gz"
  sha256 "b77acdae8a7600db9576fc749292742c109167648005513035dea767e45a00df"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "51fe60af57f3f4cd8c7447962cfe525c96e0a3f081783e2dc4414d5f5ab0914f"
    sha256 cellar: :any,                 arm64_sequoia: "220db4781b28908f1fb4e970511bcb54c287c6c2507187a8ce7fe06885a7a985"
    sha256 cellar: :any,                 arm64_sonoma:  "d8a1392681bc014d404702b399994b9f3f18226d1c1bd9431d3b4e84e4c0ed0b"
    sha256 cellar: :any,                 sonoma:        "37a7e00343d7404e8cd79b51b138e605be27c07bead26447c6bdb559d808bba4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dde48c42bd35235b45ecf126662a8111d84af7035deec32b72253722aa514b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abaa5472c2160d875d5c7441b0fb5478b6f0b72b867054f940968d3efa2d3dcf"
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
