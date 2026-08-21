class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/refs/tags/2.17.tar.gz"
  sha256 "065fe06c06788d97c35f563796d59f00ce52fe9558a52d7b490a042a966facce"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5fdef5384f4e3db814cae94a37968c1d810bd812cc6a668deabaf1fb990093a8"
    sha256 cellar: :any,                 arm64_sequoia: "8690f319a94b509377c6db22129ff83c2d3b57f5ec53fd37018b5305e6aeef2f"
    sha256 cellar: :any,                 arm64_sonoma:  "f523ac7277ea7f684101442c7fe95ca5cc499f98ede177082d5d9cf25e02b49f"
    sha256 cellar: :any,                 sonoma:        "1881b7372626c5072e5ed4522d4af2c80786cd7a74eaa38822340367c17a01ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa85819b1c60679b5fe35d3a6bfc5c6150219ad18ddd188ee5664128f32550f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75b740db8f890d9877cbae6441375d9c960f971252ca2b2331396b412fbad3d2"
  end

  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args
    ENV.deparallelize
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = Hardware::CPU.arm? ? "aarch64" : Hardware::CPU.arch.to_s
    target = if OS.mac?
      "apple-darwin#{OS.kernel_version}"
    elsif Hardware::CPU.arm?
      "unknown-linux-gnu"
    else
      "pc-linux-gnu"
    end

    bin.install "pjsip-apps/bin/pjsua-#{arch}-#{target}" => "pjsua"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end
