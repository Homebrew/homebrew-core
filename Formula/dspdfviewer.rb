class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "http://dspdfviewer.danny-edel.de"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  revision 4

  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    cellar :any
    sha256 "aacaaa14ba42537f46e13f0851e966b2cbf624924962e47f9302323848de4d25" => :high_sierra
    sha256 "e4fe9053eb4ce166ecde56385dc3deed7a3567f59206c9304a5a5975caa19823" => :sierra
    sha256 "ab541fdbce6225d913c14e93a75a996dc4738727ac9bd94c50a9e29b06c000af" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "poppler" => "with-qt"
  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-DUsePrerenderedPDF=ON"
    args << "-DRunDualScreenTests=OFF"
    args << "-DUseQtFive=ON"
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"dspdfviewer", "--help"
  end
end
