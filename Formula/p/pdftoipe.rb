class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.2.tar.gz"
  sha256 "c8de0dc7eb8fa959c96539fb19ebfb8e16f459e9b4ef9259aeb30b76072cd083"
  license "GPL-2.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1210cd0771f9461b7e92b1b4cede74fa6f4b12c517cb76431466ff7e80f12f81"
    sha256 cellar: :any, arm64_sequoia: "6a92ef6284521331dbba8d0f6d027758372371bde0caf21e48f547cb21c52c1f"
    sha256 cellar: :any, arm64_sonoma:  "8d9beb56269ffd0463bfaf6f1ee6e06770bd606d9088f422d68a6a321333cbb3"
    sha256 cellar: :any, arm64_linux:   "7e4095055e683f54f70fe507cab0b198b0e68f14baa654d6194b1ae670901263"
    sha256 cellar: :any, x86_64_linux:  "6b2c8ee3d505c166d88cb43ba36b42614f061fe235bc170528b7156d9c40bf2f"
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
