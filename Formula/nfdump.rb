class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/v1.6.22.tar.gz"
  sha256 "437536acb02258f8e2cd1e63c801428c65e1c33100e349acbf718c5b04734bd0"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git"

  bottle do
    cellar :any
    sha256 "8b95391ffbd97f144d1cdea4945093f494aec8120c570d38f25cbd42729aebfc" => :big_sur
    sha256 "c90a3f486a0e3a293ac6f2e0ef6961df6470fd68e16a73b9c27d7a566496dc6a" => :arm64_big_sur
    sha256 "300a64cf78b7d538b5249998ee8e350f50488a07a44ec5e69184f53a5dddabac" => :catalina
    sha256 "3050b7c2150db127f26d4ecddcb4e4339b7066a5810002d04481f3bd2ff89547" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--enable-readpcap"
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
