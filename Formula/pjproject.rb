class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "http://www.pjsip.org/"
  url "http://www.pjsip.org/release/2.4.5/pjproject-2.4.5.tar.bz2"
  sha256 "086f5e70dcaee312b66ddc24dac6ef85e6f1fec4eed00ff2915cebe0ee3cdd8d"

  bottle do
    cellar :any
    sha256 "5add6b979ffcb341c39255c49fd71fa11cf7e3a74ef218f647281628e86fc378" => :sierra
    sha256 "38f3a930783d7236623b0d90d1be5ab8334c126a49cde9b49dd12cbe1e601b7c" => :el_capitan
    sha256 "5c4ace5e1cf0aebf00f6a02967a09164659c4adbe24221f54bc4c2d8e6777db5" => :yosemite
    sha256 "3fb7e329490962df23a0d89574d3469abb2a9dbc9cd279133f4eff79cc1744f6" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "dep"
    system "make"
    system "make", "install"
    bin.install "pjsip-apps/bin/pjsua-#{`uname -m`.chomp}-apple-darwin#{`uname -r`.chomp}" => "pjsua"
  end

  test do
    system "#{bin}/pjsua", "--version"
  end
end
