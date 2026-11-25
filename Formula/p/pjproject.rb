class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/refs/tags/2.18.tar.gz"
  sha256 "3b5e875d6023e608b3230901cc50b08582d8483a647d0c11578ac29f39101634"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

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
