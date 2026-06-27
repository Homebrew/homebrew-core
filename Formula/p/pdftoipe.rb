class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.2.tar.gz"
  sha256 "c8de0dc7eb8fa959c96539fb19ebfb8e16f459e9b4ef9259aeb30b76072cd083"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "35fa50f2cea96b23383e0d01ee4f531dcf87b87ad2ded1f33f6c81b3d9ba33c9"
    sha256 cellar: :any, arm64_sequoia: "33379ce48cbb1eedb1853131f05a700dd146d86f386edae01b61bac9be17e8fe"
    sha256 cellar: :any, arm64_sonoma:  "6d3ab3aad33a242fa7c1feabf24568ddc9686e7b2ecfbe23209843048a6aa3d3"
    sha256 cellar: :any, sonoma:        "55df7423ed5672d881b16aa41c425d15bb545dcd68bf015de4dfde407fb2288b"
    sha256 cellar: :any, arm64_linux:   "cc75350f28550036d26fd4c17c222371a5316775f8d03afc6fdc3ce5ec10e901"
    sha256 cellar: :any, x86_64_linux:  "98a08fe7f0b2818f047a410cdbd32e1e77a4c22e85a9a99dd033c3d9483abf1f"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

  # Workaround for poppler 26.06.
  # PR ref: https://github.com/otfried/ipe-tools/pull/82
  patch do
    url "https://github.com/otfried/ipe-tools/commit/3875da3ae31515dad4f2aa7ac5f59f2c2f70c32c.patch?full_index=1"
    sha256 "15369effacfa0df2559049a1dcc01f20036b0a158bb3059c6ce333287549de7a"
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
