class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/2.11.1.tar.gz"
  sha256 "45f6604372df3f49293749cd7c0b42cb21c4fb666c66f8ed9765de004d1eae38"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "dd65ff7722e647f5441aad3eba86a3493274f4850169b3332b7c2527ba38031d"
    sha256 cellar: :any,                 big_sur:      "31319f83ddc57bc93650d5fc1890869b823ebc04f8584a9c280e23ab8d8e2caf"
    sha256 cellar: :any,                 catalina:     "90b5e44910157070b4e1d9b494076c30cf16d9b1ef9790cfa080331348dfea89"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "51fbe4542de05e29af4379cc48b8702560032197b829033806c85a0c70e04928"
  end

  depends_on macos: :high_sierra # Uses Security framework API enum cases introduced in 10.13.4
  depends_on "openssl@1.1"

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
