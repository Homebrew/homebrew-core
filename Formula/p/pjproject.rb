class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/refs/tags/2.15.1.tar.gz"
  sha256 "8f3bd99caf003f96ed8038b8a36031eb9d8cd9eaea1eaff7e01c2eef6bd55706"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6934065fa7d3cf8901366cb2a892aa434cced856977d74ed3c39826a9108b769"
    sha256 cellar: :any,                 arm64_sonoma:  "37aee9503222ef91a2b238f04655f915f6f4cb64666a81250b3fda956559afd5"
    sha256 cellar: :any,                 arm64_ventura: "8a168da1989261e327802b0416972f5dd7a743598da0607a99ba3f19d2fba116"
    sha256 cellar: :any,                 sonoma:        "04c5521468cab3b1985f3a9ad0d936bdaddf84c3bf20cc907465672a500ae530"
    sha256 cellar: :any,                 ventura:       "142ed76d42dc51b501f2efadeb7ef4dfe214ad90bc64e93447fb80a591e67705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0fb2516ec89621fc3622cd52ed7dfa0d814f49f496c32ec6763c2a8f605be66"
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
