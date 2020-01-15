class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.3.4.tar.gz"
  sha256 "cc3ccd7a23990b76dd6083e774d28f63d726a86db3a7f180b1c90596b735d5ed"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    rebuild 1
    sha256 "b65b794725b5c60423cb97f6283aac5a7e4c348a112aad160605501eed96b7dd" => :catalina
    sha256 "0549b04e7edd7cb9831d5981fb43ad8e0ae92459f5c00b2e80520f32b6d1bf84" => :mojave
    sha256 "ab33199fc0198e8ec4fe35811a86d7c475eef84359ed03b42633515731b8542c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "vala" => :build
  depends_on "gst-plugins-good"
  depends_on "gtk+3"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "poppler"

  # Build with recent vala, remove in next release
  # https://github.com/pdfpc/pdfpc/pull/446
  patch do
    url "https://github.com/pdfpc/pdfpc/commit/afd0fc83.diff?full_index=1"
    sha256 "8f2769696229393fe179b637f261fcf47128f4dd8026446d74e65483f1dbea36"
  end

  def install
    system "cmake", ".", "-DMOVIES=on", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/pdfpc", "--version"
  end
end
