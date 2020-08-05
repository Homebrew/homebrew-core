class Pkgdiff < Formula
  desc "Tool for analyzing changes in software packages (e.g. RPM, DEB, TAR.GZ)"
  homepage "https://lvc.github.io/pkgdiff/"
  url "https://github.com/lvc/pkgdiff/archive/1.7.2.tar.gz"
  sha256 "d0ef5c8ef04f019f00c3278d988350201becfbe40d04b734defd5789eaa0d321"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd5fb92603b642be4817bda4d829389cb6dfe040fddda33d2897aba8c04dd9d1" => :catalina
    sha256 "8de5a84d08a9bc063313a7319be93cbaba8b4e293e2604552e2771d9f9c93d81" => :mojave
    sha256 "28ed130d50f00ec5617be39a8bc627591d310d47e8023844b54f27fbf0daede8" => :high_sierra
    sha256 "fc92f55909e0499c1d0054100183567465603ac85fa9f8b20d5ab1d84e36ceae" => :sierra
    sha256 "18895054433b4b050c3a863306c62a910be7fa4e36b0020a742c5c7541c0df65" => :el_capitan
    sha256 "c566b1a44ed89a1b7b3547adf0a0e0fa784174e1acc4a1dd46a240ea6d09bbff" => :yosemite
    sha256 "a9ccac49037c91c63af967e67256daa24e878f38fd17959ba30fffb8e1fcc2a2" => :mavericks
  end

  depends_on "binutils"
  depends_on "gawk"
  depends_on "wdiff"

  def install
    system "perl", "Makefile.pl", "--install", "--prefix=#{prefix}"
  end

  test do
    system bin/"pkgdiff"
  end
end
