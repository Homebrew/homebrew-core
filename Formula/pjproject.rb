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
    sha256 cellar: :any,                 arm64_monterey: "ae7ac8144de063925b9ddcdfac52ec5cfa8286fc0e21255ef1cc11b36270b726"
    sha256 cellar: :any,                 arm64_big_sur:  "ebe2c56bf87c397d2e2269acfbfc345b54f3a8b117515fad1827c20da620a227"
    sha256 cellar: :any,                 monterey:       "dd65ff7722e647f5441aad3eba86a3493274f4850169b3332b7c2527ba38031d"
    sha256 cellar: :any,                 big_sur:        "31319f83ddc57bc93650d5fc1890869b823ebc04f8584a9c280e23ab8d8e2caf"
    sha256 cellar: :any,                 catalina:       "90b5e44910157070b4e1d9b494076c30cf16d9b1ef9790cfa080331348dfea89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51fbe4542de05e29af4379cc48b8702560032197b829033806c85a0c70e04928"
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
