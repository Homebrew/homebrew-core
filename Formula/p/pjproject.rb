class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

  stable do
    url "https://github.com/pjsip/pjproject/archive/refs/tags/2.17.tar.gz"
    sha256 "065fe06c06788d97c35f563796d59f00ce52fe9558a52d7b490a042a966facce"

    # Backport support for OpenSSL 4.0
    patch do
      url "https://github.com/pjsip/pjproject/commit/3923fad2e4f6f3403c3d6f1176b113c1c1b91066.patch?full_index=1"
      sha256 "6958040fc0b0502381aa1514cacf1d947ea1a6104b2da388e1c99870f67bc998"
      type :backport
      resolves "https://github.com/pjsip/pjproject/pull/5036"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "0569bd6c0aec33fea3a8f97f7e57e2536041ce987c0a44d6263d4ac91c4eddea"
    sha256 cellar: :any, arm64_tahoe:       "2d834c5d4559992257c1bff7ee49665c5cb97ec1ed2882f70740e0821863698d"
    sha256 cellar: :any, arm64_sequoia:     "64e9ca3a5a794470f0396fcbe5d7222e1801870e42d378d28d33329c03c56d74"
    sha256 cellar: :any, arm64_linux:       "78625608c7dc0e5f407f829e281ce25b9dd7b32cf71d363814552d007d0df235"
    sha256 cellar: :any, x86_64_linux:      "7d2c1b161eec50c23a1c1538a38c5e00c2b0362c3b524720fbce5fec98476070"
  end

  depends_on "openssl@4"

  deny_network_access!

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
