class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "71993ec5e573e4f8e3ff452dc7d0c3df9e2f08a542940f19578bb90649104830"
    sha256 cellar: :any,                 arm64_big_sur:  "3c1e7a01a95419a7a85ddae59eca79c4f8add94e235f9b5274cfbbd86e8e27c0"
    sha256 cellar: :any,                 monterey:       "1e468ddfe642edc7241437e2bae279813452d3502849bde0547e65a6efb44264"
    sha256 cellar: :any,                 big_sur:        "9c4b5c435105469b2faf694db8343291624127adafc4d5e724431f63da17c6a6"
    sha256 cellar: :any,                 catalina:       "6adbd859a82a139179843984e808ac2cdcc428f5204c67e01a2097a581e7de6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "964eab28db09c3895efba2d1f7200e4551eb29368997f9523fd68abdfc20798a"
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
