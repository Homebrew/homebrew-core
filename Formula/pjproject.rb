class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "http://www.pjsip.org/"
  url "http://www.pjsip.org/release/2.7.2/pjproject-2.7.2.tar.bz2"
  sha256 "9c2c828abab7626edf18e04b041ef274bfaa86f99adf2c25ff56f1509e813772"

  bottle do
    cellar :any
    sha256 "eec232d8fe6c5b4e05521a87a4bd1a5cb4fcc6a4f0a996ddaacc33bd2d93255f" => :high_sierra
    sha256 "f7d12f6bcb2a628df0e87e4bbaffc368ca004ed6de12d11d4d019b080257a2d0" => :sierra
    sha256 "52a55c49ef0d0d53abf447fd060e7eaf8bd1d10c8f6b419582c5e453634d5b61" => :el_capitan
  end

  depends_on "openssl"

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
