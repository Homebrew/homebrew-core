class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://github.com/bstansell/conserver/releases/download/v8.3.0/conserver-8.3.0.tar.gz"
  sha256 "202b2ace3e14f36bca4de6ccd43cc962a99853c1d50799672ce0ffc5c02f8404"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "2b8c2a619a595ce76f5223d646c29fc498c66aa4fcef1531e066d64152bada23"
    sha256 cellar: :any, arm64_tahoe:       "b9639002703fb39131f766f5bf9b59fc92c223a8d561fca26888bdbe76878489"
    sha256 cellar: :any, arm64_sequoia:     "b867d5ec6b846f4ee3aab4f7f868d3dc4f2bd59cf10614821f014e4850b8fb5f"
    sha256 cellar: :any, arm64_sonoma:      "2b2571375ab3f26724d08297c7e81a0baac22f2f6a2fe1ac6c1dde7bb8e73305"
    sha256 cellar: :any, arm64_linux:       "52067bb40b928258fa727ee70b709e7f18a4dd76fbb36e24b80a1130f4a92d61"
    sha256 cellar: :any, x86_64_linux:      "e5d6c2593f8aa2d43cb8b0db6288ad9445212e8eae4025264b1117e333514fbd"
  end

  depends_on "openssl@4"

  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"

  conflicts_with "uffizzi", because: "both install `console` binaries"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-openssl", "--with-ipv6", "--with-gssapi", "--with-striprealm"
    system "make"
    system "make", "install"
  end

  test do
    console = spawn bin/"console", "-n", "-p", "8000", "test"
    sleep 1
    Process.kill("TERM", console)
    Process.wait(console)
  end
end
