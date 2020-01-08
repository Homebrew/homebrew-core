class Clens < Formula
  desc "Library to help port code from OpenBSD to other operating systems"
  homepage "https://github.com/conformal/clens"
  url "https://github.com/conformal/clens/archive/CLENS_0_7_0.tar.gz"
  sha256 "0cc18155c2c98077cb90f07f6ad8334314606c4be0b6ffc13d6996171c7dc09d"

  bottle do
    cellar :any_skip_relocation
    sha256 "fef1ad76413e8e15683a4066276ed7f37f821edcbda4e6d648bd60e09a33a30d" => :catalina
    sha256 "3550adf8f1e9eb8e62ac6c64f3b3c8cae0fba0d0f958f6e6da99e74f4e4d5e19" => :mojave
    sha256 "e9dfe6e9228a928f9cb1a4048d92ec576be5f89f48408401b7f3020c1482a7c6" => :high_sierra
    sha256 "f034c79bf5a16265db249c673b2d2a3e6850676dba739adeb6e90394d8f77475" => :sierra
    sha256 "f6c68d7dce9d824274e16e3867926528cc79d161418fac0a0052e37dc6604668" => :el_capitan
    sha256 "b08580c90a8ed647005c437158972a1dbd770792c2db74391eec8ed5f4ec1b6e" => :yosemite
    sha256 "e3642b0982f846103eace85598f242e982ead98bbc8963b58e4192b2d1b1ae84" => :mavericks
  end

  patch do
    url "https://github.com/conformal/clens/commit/83648cc9027d9f76a1bc79ddddcbed1349b9d5cd.diff?full_index=1"
    sha256 "efd43aa84f7ff1582c3716282ac1b3b650c16af9a0f55039d20bfd4b085188e2"
  end

  def install
    ENV.deparallelize
    system "make", "all", "install", "LOCALBASE=#{prefix}"
  end
end
