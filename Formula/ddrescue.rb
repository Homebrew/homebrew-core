class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.24.tar.lz"
  mirror "https://ftpmirror.gnu.org/ddrescue/ddrescue-1.24.tar.lz"
  sha256 "4b5d3feede70e3657ca6b3c7844f23131851cbb6af0cecc9721500f7d7021087"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0c838d3c677d4959c1460929cdcda44a3547c91595f1990bc86155a433a2ef5" => :catalina
    sha256 "4607386b3581f9243aa870c58bd8be80a60dbd18bdbb6bd092685876b99849d7" => :mojave
    sha256 "ad2a428fe7506bb53bb7084dd4b69c5738dd8f3cce65d266082731439401462d" => :high_sierra
    sha256 "b417104d0741c312dbaa916711c1642b74fe3d846b3c57441a93bd264b4ef608" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system bin/"ddrescue", "--force", "--size=64Ki", "/dev/zero", "/dev/null"
  end
end
