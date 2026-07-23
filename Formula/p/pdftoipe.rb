class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.2.tar.gz"
  sha256 "c8de0dc7eb8fa959c96539fb19ebfb8e16f459e9b4ef9259aeb30b76072cd083"
  license "GPL-2.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ebd8392222f696486dd6fd6538c2f58f094e592dbdac15a37e0b71adea09ce02"
    sha256 cellar: :any, arm64_sequoia: "0bcda174b051c92b69ab4a55158d5857e3816fe33c85424bc909d08e490586de"
    sha256 cellar: :any, arm64_sonoma:  "f7bed41f8463efa2e8e6fc3aba820718c5bbc2b6bf6a59a3018ee73049657a07"
    sha256 cellar: :any, sonoma:        "c152cd8fe8e340a61a7e8543eade06e23f0e43afbd123246441a0795b242f093"
    sha256 cellar: :any, arm64_linux:   "f5cb06fd5f7d025d21d527b1b7248a241e195459219eeab4e5e07191142c3735"
    sha256 cellar: :any, x86_64_linux:  "7915ae5fa8e4e997e115905ad929cc2f9b3c933ddeddd9a7f1d0766e02b8a3f3"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

  # Workaround for poppler 26.06.
  patch do
    url "https://github.com/otfried/ipe-tools/commit/3875da3ae31515dad4f2aa7ac5f59f2c2f70c32c.patch?full_index=1"
    sha256 "15369effacfa0df2559049a1dcc01f20036b0a158bb3059c6ce333287549de7a"
    type :backport
    resolves "https://github.com/otfried/ipe-tools/pull/82"
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
