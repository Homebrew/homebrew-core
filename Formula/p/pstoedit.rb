class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/4.02/pstoedit-4.02.tar.gz"
  sha256 "5588b432d2c6b2ad9828b44915ea5813ff9a3a3312a41fa0de4c38ddac9df72f"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "e773007c11d92ed03d522da9acddabe00010345187e10dcf2b8921bdcac62cb4"
    sha256 arm64_sequoia: "4577e541a3d69e7c9fdc3291b552e4cfb50a8a3603c080a3c2c2d1f9ea7e96a6"
    sha256 arm64_sonoma:  "b17eff3c581194a6bf0290507456b75edbbad20cde4c01793cc9754425e59712"
    sha256 arm64_ventura: "355cc44f552bd82c5cf39915449de0a4051eb2f9efba352323b87eb0403f15db"
    sha256 sonoma:        "6353b2d9287a6e0524047a32cafb61f8c09d4d476d1bc13d40b73289aace060c"
    sha256 ventura:       "bd4b577c2ed8b2f4c1b9ded0ed953365f445b29bff62e262caef589cb49d049c"
    sha256 arm64_linux:   "ae82c51bc2186d4b32fa75d8b8bceff7bec7f2da0bf20c4cf51d669d0c5a4cec"
    sha256 x86_64_linux:  "c2c8d0315852f2dca193e34433526f2635f9a8b3b6fd02ccca85646f92cbf56a"
  end

  depends_on "pkgconf" => :build
  depends_on "gd"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "plotutils"

  def install
    # Avoid Linux libc-specific behavior when building on macOS
    # Notified author about the issue via email
    inreplace "src/pstoedit.cpp", "#ifndef _MSC_VER\n", "#if !defined(_MSC_VER) && !defined(__APPLE__)\n"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"pstoedit", "-f", "gs:pdfwrite", test_fixtures("test.ps"), "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
