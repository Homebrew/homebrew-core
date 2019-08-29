class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://www.pjsip.org/release/2.9/pjproject-2.9.tar.bz2"
  sha256 "d185ef7855c8ec07191dde92f54b65a7a4b7a6f7bf8c46f7af35ceeb1da2a636"
  revision 1
  head "https://svn.pjsip.org/repos/pjproject/trunk"

  bottle do
    cellar :any
    sha256 "32547d3d6ca05978e26ed421bb1464494217964a218b5e76149ddd14c1c33f30" => :mojave
    sha256 "276438da8f875128a0ff0240a661bc2665fac9fb6ad97885666ccf81e5e56ffb" => :high_sierra
  end

  depends_on :macos => :high_sierra # Uses Security framework API enum cases introduced in 10.13.4
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = Utils.popen_read("uname -m").chomp
    rel = Utils.popen_read("uname -r").chomp
    bin.install "pjsip-apps/bin/pjsua-#{arch}-apple-darwin#{rel}" => "pjsua"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end
