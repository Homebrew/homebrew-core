class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/2.12.1.tar.gz"
  sha256 "d0feef6963b07934e821ba4328aecb4c36358515c1b3e507da5874555d713533"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5c0d63278e407a290c4b2441618c39b62e65266e6734fd4f5e71eef4a70d79ea"
    sha256 cellar: :any,                 arm64_big_sur:  "7c93064589245599a8f87517cc8801b04f5d539e6c15cf96b1c57646f3ceae82"
    sha256 cellar: :any,                 monterey:       "606cbd22a69e6a20014b605e637f0649307d31e36a5c772719e4fcdf8d373731"
    sha256 cellar: :any,                 big_sur:        "85799cc917b83ec7ad75e126cdd7d79d71359d6ea659c90c5126185294d1b7d1"
    sha256 cellar: :any,                 catalina:       "14bad2b767d8e85b1aee73992f860c1a0fa2429569ec056a53cda1dd5dcd9682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cfbdfe912c21c4f901f7f06df6e93ca81f66de13e1e94e31413cb03c1411985"
  end

  depends_on macos: :high_sierra # Uses Security framework API enum cases introduced in 10.13.4
  depends_on "openssl@1.1"

  # restore --version flag, remove in next version
  patch do
    url "https://github.com/pjsip/pjproject/commit/4a8cf9f3.patch?full_index=1"
    sha256 "2a343db0ba4c0cb02ebaa4fc197b27aa9ef064f8367f02f77b854204ff640112"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = OS.mac? && Hardware::CPU.arm? ? "arm" : Hardware::CPU.arch.to_s
    target = OS.mac? ? "apple-darwin#{OS.kernel_version}" : "unknown-linux-gnu"

    bin.install "pjsip-apps/bin/pjsua-#{arch}-#{target}" => "pjsua"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end
