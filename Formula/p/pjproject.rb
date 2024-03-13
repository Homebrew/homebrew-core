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
    sha256 cellar: :any,                 arm64_sonoma:   "e6fbbba317175eb05554d637f20bcdbceb7d36ba4cca29e388e015cdcfb18367"
    sha256 cellar: :any,                 arm64_ventura:  "998d08226d5634d630527c09303814d01876f94d3b0409513ef5f38c75f8aaf5"
    sha256 cellar: :any,                 arm64_monterey: "82554d2e6557e8c5e6fe62c45503c8d352af1759a2d9f675d5b4d537b66c7dc8"
    sha256 cellar: :any,                 sonoma:         "3e51ae140b4570ba480a43d416ef7dbcc172820815b3386a7a987f9892ab82b2"
    sha256 cellar: :any,                 ventura:        "541f801832563d1a04d91590d4a432b4962db1bf7a756c5c5d78af98974b5471"
    sha256 cellar: :any,                 monterey:       "11c32c2f615241ddd54051b4d2420208c69aee360659b9fb22d87550436aeff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7476af7aa02d0c11c930c2975213831589a99f4482beec12549094980b92f4e1"
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
