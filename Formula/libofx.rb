class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://libofx.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libofx/libofx/libofx-0.10.3.tar.gz"
  sha256 "7b5f21989afdd9cf63ab4a2df4ca398782f24fda2e2411f88188e00ab49e3069"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libofx[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "8d46f692bc2952487c01b35a9c5ca8dc3bc4fbb0dd298135001110a6a9ac7a60"
    sha256 arm64_big_sur:  "2bba6b3d799e65cac444879650535b7f683836f5b23c6e5467f5797ff788b460"
    sha256 monterey:       "cdd9daa3d8dae3abb150707beb2f4f073b93c9973638f87390a8ba8614a08c2a"
    sha256 big_sur:        "3cc86d7824a38ab40a26dc862b9edd8aa927615d98787509a8ce0e53a4970e90"
    sha256 catalina:       "0c13380f3316db596f2bc7da653b66cce4da67a57143152582f2915bc75ffd9e"
    sha256 mojave:         "0c964ef5cb85a5783e5e717e2a74a69d446191237ae7da74a3104eb03c77bb66"
    sha256 x86_64_linux:   "0539cc89e0874fe414f30db5b87edf7cfdc2d899694b8546f4312068ba408273"
  end

  depends_on "open-sp"

  def install
    ENV.cxx11

    opensp = Formula["open-sp"]
    system "./configure", "--disable-dependency-tracking",
                          "--with-opensp-includes=#{opensp.opt_include}/OpenSP",
                          "--with-opensp-libs=#{opensp.opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "ofxdump #{version}", shell_output("#{bin}/ofxdump -V").chomp
  end
end
