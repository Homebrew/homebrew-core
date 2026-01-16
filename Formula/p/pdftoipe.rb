class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 13

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e458140ae6523ea3475820d032dd70f5a393a265888a8c1d3b7ff1973517d320"
    sha256 cellar: :any,                 arm64_sequoia: "80eaeb8f45bbb3a96b00dd9987b0d4db8f4b6d4a4002225c801ccf7b999d39d3"
    sha256 cellar: :any,                 arm64_sonoma:  "44bbb9e7b11499efa631d60cdd7e3547b92d75901549113b496707085d8fbd1f"
    sha256 cellar: :any,                 sonoma:        "76fa0169012ab888fe0c67b3881dcdbb5698a600805f64223c8318c2be1a9763"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "267054e95a5198879301dfd50d7395fe431a993f6aa1f0c5e30981a6cca5262e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81410873242c35cda5b1bc12c56a11ded781ef6c2947ef40b876286823ff3822"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

  # Backport fix for `poppler` 25+ compatibility
  # PR ref: https://github.com/otfried/ipe-tools/pull/72
  # PR ref: https://github.com/otfried/ipe-tools/pull/77
  patch do
    url "https://github.com/otfried/ipe-tools/commit/0da954e50fbdedf43796291853890fe36248bc16.patch?full_index=1"
    sha256 "65f7010897fa4dd94cfa933d986cae6978ddd4e33e2aa1479ec7c11786e100c3"
  end
  patch do
    url "https://github.com/otfried/ipe-tools/commit/2f59d3b747a23cd4b13b09ebee9f703b8129116c.patch?full_index=1"
    sha256 "b1b48088c9dd4067d862d788643c750fc6981102cd85f62a85f898948ca33771"
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
