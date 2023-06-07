class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/2.13.tar.gz"
  sha256 "4178bb9f586299111463fc16ea04e461adca4a73e646f8ddef61ea53dafa92d9"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ccee5a9791d7286f541e9f59931f5c2193af1e0ca0ad189cb5dbe56826036ff5"
    sha256 cellar: :any,                 arm64_monterey: "71ba504dd2255cfba6d1867d27add23f415a841c0dea2a96cced2f5868c0645a"
    sha256 cellar: :any,                 arm64_big_sur:  "89e39245774453366e922ccca427a5ef2d70809a7fc952e89b095ba884830998"
    sha256 cellar: :any,                 ventura:        "e5f65e36cef12259e4d690959b31a3a1345635b65d4a34b212873e8ed1272a5a"
    sha256 cellar: :any,                 monterey:       "66b92f14f4d14a45e55bdf306311cb2bbd0fca3573e2aa03900d4c4b1d427e6d"
    sha256 cellar: :any,                 big_sur:        "29ea64bce5012253aacc4ccf1cd43c8ec701ccf625739341817c6d452a9cc44e"
    sha256 cellar: :any,                 catalina:       "7265ffaa44bdc67e47721c12d80cf7e7d213f47a393d8923ceadeaee9968e68e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "026e78e19b27cdba146d7e90399a0e696dde30c8854bebe031cfecf622126104"
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
