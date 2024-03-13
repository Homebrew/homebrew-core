class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/refs/tags/2.14.1.tar.gz"
  sha256 "6140f7a97e318caa89c17e8d5468599671c6eed12d64a7c160dac879ba004c68"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7cbe740f0f13ea2c0d8dcc6384d1acc6357476f58fcd50f815549c1c3f92704f"
    sha256 cellar: :any,                 arm64_ventura:  "da372046133e86b3d10be588ab7fb5908f07a722d4a3510ea69034b575f3c9bf"
    sha256 cellar: :any,                 arm64_monterey: "4fd17966fa4c58310768ded4332fb3dc5472d528e129d9bd6dbd10418e2fdbae"
    sha256 cellar: :any,                 sonoma:         "cba78c11dab9623882dd3177d547b204bc85dfb3bfbf50d725e898935e67824f"
    sha256 cellar: :any,                 ventura:        "4216c9b78cf283ffea7fb6eee5bae66ee15c12e849ce643ba737a76289ed575f"
    sha256 cellar: :any,                 monterey:       "863d2bafd39e147a1c99a700ccfd94fc4e7eddee6242d332260b421a7590e84f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ff1d1b16318f98c5213a732f31658ab14c990d1c0608a4f26601cd1d91fdf60"
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
