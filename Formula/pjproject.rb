class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/2.10.tar.gz"
  sha256 "936a4c5b98601b52325463a397ddf11ab4106c6a7b04f8dc7cdd377efbb597de"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 big_sur:      "b62ae1e3e6b33e093d69968bf0fa6708634075fb500e6cfb88d07a90d47a85cd"
    sha256 cellar: :any,                 catalina:     "ce9e2f67c5ae7148b7c7883ac3c6dbcc9dd7892695af93c02dc44b3e52f109dd"
    sha256 cellar: :any,                 mojave:       "26c273e3e975fc955f3c8ffb03c8332629fd42f123a4144645adb30817f9f428"
    sha256 cellar: :any,                 high_sierra:  "114939ba488f6f78f1d337d27eb1873aacfb9c55788b60543f6dbab7e23f745e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9c21e926d07a2d72369a433fc3421a80a0078827326831202dd78533c57da7ac"
  end

  depends_on macos: :high_sierra # Uses Security framework API enum cases introduced in 10.13.4
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = Utils.safe_popen_read("uname", "-m").chomp
    if OS.mac?
      bin.install "pjsip-apps/bin/pjsua-#{arch}-apple-darwin#{OS.kernel_version}" => "pjsua"
    else
      bin.install "pjsip-apps/bin/pjsua-#{arch}-unknown-linux-gnu" => "pjsua"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end
