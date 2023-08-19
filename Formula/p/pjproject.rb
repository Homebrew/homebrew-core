class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/refs/tags/2.13.1.tar.gz"
  sha256 "32a5ab5bfbb9752cb6a46627e4c410e61939c8dbbd833ac858473cfbd9fb9d7d"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f726f77dd38e734ea7f87fa9c1b98a1ecbc1ef1c69e94868242c866f2c74e087"
    sha256 cellar: :any,                 arm64_monterey: "056ddd3d616ef3cec8a08d83256c057589ecdbda9e517ebb8aeca446dfd0a2f5"
    sha256 cellar: :any,                 arm64_big_sur:  "99685833f0e06c4daa44831d8b04d11100a435eda000e788efcd0bd6e1030f51"
    sha256 cellar: :any,                 ventura:        "7762d02b800fc958741659fac1cf44be6fd398bca506c0862d7d82e50276a876"
    sha256 cellar: :any,                 monterey:       "721afc38bbdd1f5aeadaa7dae3931be0973ee72c5e90596d7a50172bbf36edf9"
    sha256 cellar: :any,                 big_sur:        "21f80abae30db9f098f5385cd7c36f037639d7d2826c490ad74a5a50b8f556f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2d9ff66e28752db7570bf2a9e35235839a5b1c33c73ba06249880e2e3c62f4b"
  end

  depends_on macos: :high_sierra # Uses Security framework API enum cases introduced in 10.13.4
  depends_on "openssl@3"

  def install
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = (OS.mac? && Hardware::CPU.arm?) ? "arm" : Hardware::CPU.arch.to_s
    target = OS.mac? ? "apple-darwin#{OS.kernel_version}" : "unknown-linux-gnu"

    bin.install "pjsip-apps/bin/pjsua-#{arch}-#{target}" => "pjsua"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end
