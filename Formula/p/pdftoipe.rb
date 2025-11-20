class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 11

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aef4d333bf099830d1c9a08fb5d1fe329502388fe71e9e4658de6daece1d2934"
    sha256 cellar: :any,                 arm64_sequoia: "c360cf7ac7f4f2c2f887be1c93290796dc4e2fc94f3bce37a305a28484eeb2f7"
    sha256 cellar: :any,                 arm64_sonoma:  "d28e0ed8bf6e83a58bb4c74ccf713f70310f48f83270ce7fcdb1d98efbdec60d"
    sha256 cellar: :any,                 sonoma:        "9a42dc11e7fd571ba972d352805d605e613224dbad138cc92effa55ac0a3db55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81fdef81bd707c301ce8f6b2ae0402e5ed40f5c55aff96e1602339e69819f616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b390f2ea059095ed3e38fffbcea9ed892024d276165d5e86d42ea0a74f9022f0"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

  # Backport fix for `poppler` 25+ compatibility
  # PR ref: https://github.com/otfried/ipe-tools/pull/72
  patch do
    url "https://github.com/otfried/ipe-tools/commit/0da954e50fbdedf43796291853890fe36248bc16.patch?full_index=1"
    sha256 "65f7010897fa4dd94cfa933d986cae6978ddd4e33e2aa1479ec7c11786e100c3"
  end

  def install
    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end
