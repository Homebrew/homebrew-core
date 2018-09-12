class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.1.2.tar.gz"
  sha256 "0fcacd0deac39d93e21fc152b0cb01279b4ba209934fe385be6811236a03c87d"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "fe211f5e2a05d5ec68dbf8fe100c14bbb8557b2e9b9421dfef80e1e7005e90d9" => :mojave
    sha256 "ba05dcf5419fa5e23a64c2469b4d0a2110650dc75b19c6750533d860ac771e10" => :high_sierra
    sha256 "5ecb69f0c8268691f3e8d0b19123ba6b715182b78dfa66cade71712ee53a2567" => :sierra
    sha256 "c3bfbe06af39c2882944751ad0f7ddbbe9001a6a907077bbbaa0a3b894d21d9f" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "poppler"

  def install
    system "cmake", ".", "-DMOVIES=off", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/pdfpc", "--version"
  end
end
