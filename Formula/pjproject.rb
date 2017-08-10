class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "http://www.pjsip.org/"
  url "http://www.pjsip.org/release/2.6/pjproject-2.6.tar.bz2"
  sha256 "2f5a1da1c174d845871c758bd80fbb580fca7799d3cfaa0d3c4e082b5161c7b4"

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

    arch = Utils.popen_read("uname -m").chomp
    rel = Utils.popen_read("uname -r").chomp
    bin.install "pjsip-apps/bin/pjsua-#{arch}-apple-darwin#{rel}" => "pjsua"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end
