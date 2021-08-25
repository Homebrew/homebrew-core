class Crfxx < Formula
  desc "Conditional random fields for segmenting/labeling sequential data"
  homepage "https://taku910.github.io/crfpp/"
  url "https://mirrors.sohu.com/gentoo/distfiles/f2/CRF%2B%2B-0.58.tar.gz"
  mirror "https://drive.google.com/uc?id=0B4y35FiV1wh7QVR6VXJ5dWExSTQ&export=download"
  sha256 "9d1c0a994f25a5025cede5e1d3a687ec98cd4949bfb2aae13f2a873a13259cb2"
  license any_of: ["LGPL-2.1-only", "BSD-3-Clause"]
  head "https://github.com/taku910/crfpp.git", branch: "master"

  # Archive files from upstream are hosted on Google Drive, so we can't identify
  # versions from the tarballs, as the links on the homepage don't include this
  # information. This identifies versions from the "News" sections, which works
  # for now but may encounter issues in the future due to the loose regex.
  livecheck do
    url :homepage
    regex(/CRF\+\+ v?(\d+(?:\.\d+)+)[\s<]/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_big_sur: "763da462b53ce92f9feae23750b038b96e79b121b7bdfa4c0d1c99701c3345d4"
    sha256 cellar: :any,                 big_sur:       "fcf0862271c392bc7b69a4e02a74dd9bd85615b6be0273009e7611bb78298f61"
    sha256 cellar: :any,                 catalina:      "6706e1cb8b242ed58885402da7b41cd1552f206407fc18c200907f3c64a7b9c5"
    sha256 cellar: :any,                 mojave:        "814479e15702bd1ef9afba98ff5030bbf7cd90810f2561863d1b9085a230ee8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc105b0deaa5661ba6cde2ac18b289ef676aacfad93f569e659d1ce6035127f"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "CXXFLAGS=#{ENV.cflags}", "install"
  end

  test do
    # Using "; true" because crf_test -v and -h exit nonzero under normal operation
    output = shell_output("#{bin}/crf_test --help; true")
    assert_match "CRF++: Yet Another CRF Tool Kit", output
  end
end
