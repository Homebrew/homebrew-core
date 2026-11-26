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
    manifest_sha256 "50836992056a18c007bf296e36c87075a02e9c718e42e6d69f4a251f4ff38b48"
    sha256 cellar: :any, arm64_golden_gate: "c4e145703e8964de139a1d8fb9d82505b3b171493743248d2a070809ded929e0"
    sha256 cellar: :any, arm64_tahoe:       "3ff6414d6f902b6cf489ab5c6247fc1a1823407dadd7cb0f5aeb109381216671"
    sha256 cellar: :any, arm64_sequoia:     "d04bca532f712bb4ebaf7dc6dc8a32cfa735935b1cdee863139f6fa2223e3043"
    sha256 cellar: :any, arm64_linux:       "7c79cc0103c4b28a52ad745996f6d8cb897c6d17a133ef93bd49708643ff3253"
    sha256 cellar: :any, x86_64_linux:      "67d9c78bcc5da5b60adc4738a76f3aa02c90ad497eadb34a439f4c2399337a1a"
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
