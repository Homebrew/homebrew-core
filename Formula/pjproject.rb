class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/2.10.tar.gz"
  sha256 "936a4c5b98601b52325463a397ddf11ab4106c6a7b04f8dc7cdd377efbb597de"
  license "GPL-2.0"
  head "https://github.com/pjsip/pjproject.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "b62ae1e3e6b33e093d69968bf0fa6708634075fb500e6cfb88d07a90d47a85cd" => :big_sur
    sha256 "ce9e2f67c5ae7148b7c7883ac3c6dbcc9dd7892695af93c02dc44b3e52f109dd" => :catalina
    sha256 "26c273e3e975fc955f3c8ffb03c8332629fd42f123a4144645adb30817f9f428" => :mojave
    sha256 "114939ba488f6f78f1d337d27eb1873aacfb9c55788b60543f6dbab7e23f745e" => :high_sierra
  end

  depends_on macos: :high_sierra # Uses Security framework API enum cases introduced in 10.13.4
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = Utils.safe_popen_read("uname", "-m").chomp
    bin.install "pjsip-apps/bin/pjsua-#{arch}-apple-darwin#{OS.kernel_version}" => "pjsua"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end
