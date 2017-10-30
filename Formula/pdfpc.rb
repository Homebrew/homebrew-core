class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.1.tar.gz"
  sha256 "aee684cc4b6cd8f2f83196ebd42608b9917104c9b1572985797daf1ae68e5454"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "642f39b28a729432c2e37913b556778cab49f2f62a8da70fef96529e77b9c82b" => :high_sierra
    sha256 "220fd34090fac0af70f2b36ddc4e447d5ddd28e89b43b32903943f64d63bec24" => :sierra
    sha256 "273f35b40ef13f7127757e326735fe4568113eff33e07bd2dac8368bd67bb66b" => :el_capitan
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
