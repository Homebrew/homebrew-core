class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "99cb899f3d5790f91a4b1de0f5731c409744df246ce79b97775aaaf00c58e2be"
    sha256 cellar: :any, big_sur:       "24fbd7e2064200c33ba600cbd3608c4633ea962434edbabc7c44fc3459e1c4fb"
    sha256 cellar: :any, catalina:      "420250312abd7c3cd740c8fdf1d95c1ed06d25836e2d12f4bf9cf7ea0499772f"
    sha256 cellar: :any, mojave:        "d40bb7517d27d51127030997b04953bd47d64f916d384e3d4c842c1ee162f1fc"
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    ENV.cxx11

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
