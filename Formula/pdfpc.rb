class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.1.2.tar.gz"
  sha256 "0fcacd0deac39d93e21fc152b0cb01279b4ba209934fe385be6811236a03c87d"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "93420f1585f6799bc4b7ffa7ba3d3d77e15927256ca536f4e2218ddc279f4cd8" => :high_sierra
    sha256 "cd12ae98a2eba181965914ef607f54ae9abbcd5bf749c0438e0904f4ad51483b" => :sierra
    sha256 "992c072e5944b9790084a11b941028c699f29b861f7515c7e554ce31302dff9d" => :el_capitan
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
