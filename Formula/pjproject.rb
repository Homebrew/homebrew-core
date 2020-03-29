class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/2.10.tar.gz"
  sha256 "936a4c5b98601b52325463a397ddf11ab4106c6a7b04f8dc7cdd377efbb597de"
  head "https://github.com/pjsip/pjproject.git"

  bottle do
    cellar :any
    sha256 "e31037429a94ebfae5fa04dd72401621dcd7b7628ba4f3f8dd6c096b13de3e50" => :catalina
    sha256 "5c8504312c89836f834b61b9f006044e37e76606290965de8a0e8ffd57275303" => :mojave
    sha256 "bf68bae907d0ee4cc1accfd788e41a8fb8c558acd5fd781b81f5547571e04fa1" => :high_sierra
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
