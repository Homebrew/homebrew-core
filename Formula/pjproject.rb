class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "http://www.pjsip.org/"
  url "http://www.pjsip.org/release/2.7.1/pjproject-2.7.1.tar.bz2"
  sha256 "59fabc62a02b2b80857297cfb10e2c68c473f4a0acc6e848cfefe8421f2c3126"

  bottle do
    cellar :any
    sha256 "6b5ac553cdb40d47f6e35ffd0b52736678b929bc6eaa463caa611adca1d52ef9" => :high_sierra
    sha256 "37fbe15419028b6057780e26403faf91fc963b815e1599ae336d9abae04878f8" => :sierra
    sha256 "395f3e6103bccaca54622224653e42d2aa02c5dfd09783e7dc04166c9987a831" => :el_capitan
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
