class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/refs/tags/2.16.tar.gz"
  sha256 "3af2e481d51aaa095897820fa2ee26c30e530590c6ca56d23e4133bbdad369eb"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4f4759b98ee06a57828e8856cff7b36aa4b0e0652fd55d9eb78767ca9ec5c2b"
    sha256 cellar: :any,                 arm64_sequoia: "6a226b89651d7e80ed814feb9dad408d152d929bb9f60464a0135c003bf28374"
    sha256 cellar: :any,                 arm64_sonoma:  "9e2fc597965b890617e1a7c62d3b60c2fe6edfb4e8cab9a0556f6b6012cfe230"
    sha256 cellar: :any,                 sonoma:        "249cc452f8cb427f81dd8061bd197cc8c4ffd2cd13e68d603341c73140f1f5c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fa832c7c13f2c63052af9cff12041dd64f1bdb881fe8fdaee7af3a7e1962512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1196e71656f577d3126a134beb06b1b6bbecff6806238165773a295c95fb5385"
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
