class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "167884a3aef169ca68c66039aef5c490a69fc6b03456079dbc86e8e4ddcbff52"
    sha256 cellar: :any,                 arm64_big_sur:  "92c16b5e8fe2037f930bf2d61d0942ce3d1db2f4195cffe4aa96f3e2fcb1550f"
    sha256 cellar: :any,                 monterey:       "c91450a786fccc95346fac43f9dee761377c5ed573a63844cc29fdf1961c4ced"
    sha256 cellar: :any,                 big_sur:        "6046385045bdaa58bbccecec2a457384854d3bd80073c7022de94c5b3969ddc7"
    sha256 cellar: :any,                 catalina:       "7d2237b936e622f594fcdf11e030c993a2cd87c007bf479e8216ae84b9f6e7e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1148b14f2d046e9f264bac8cea05d888620171a2e9547ff8a9c046d2ab805b2"
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # https://github.com/otfried/ipe-tools/pull/48
  patch do
    url "https://github.com/otfried/ipe-tools/commit/14335180432152ad094300d0afd00d8e390469b2.patch?full_index=1"
    sha256 "544d891bfab2c297f659895761cb296d6ed2b4aa76a888e9ca2c215d497a48e5"
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
