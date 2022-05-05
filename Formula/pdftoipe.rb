class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bceee4018ecd7f4f280345845c30566cee4358390ea9c379295e382509e72f02"
    sha256 cellar: :any,                 arm64_big_sur:  "6aa0eba430465833f13ad614b6e6bcaab7089112acf8f4fcaf0e77fae85ac46c"
    sha256 cellar: :any,                 monterey:       "9c33ba1d05f59b1904605d7d614ac513a3b8806e3a75487da081541a6bb49081"
    sha256 cellar: :any,                 big_sur:        "a1101f84668e561899a18a8413f476283826720c7069bab288b55893db14b259"
    sha256 cellar: :any,                 catalina:       "57c2aba52c28b8f86a6ba120a9c3202df5e92b61fd3d41758545776ea0861c9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8502504cda36752bfa39d332dd777fe280a69a1385721423b6eddf594db80f1e"
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
