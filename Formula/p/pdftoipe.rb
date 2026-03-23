class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.2.tar.gz"
  sha256 "c8de0dc7eb8fa959c96539fb19ebfb8e16f459e9b4ef9259aeb30b76072cd083"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b0514955c452b9caac3b8fe502f4b1aa3eb6c05666002e0b39d0ea3f76ce91f"
    sha256 cellar: :any,                 arm64_sequoia: "4eb658e9e51ce83bd51a0a8e40f3cfd5cad8642e2d44bab8f0d7a6ef4733bad5"
    sha256 cellar: :any,                 arm64_sonoma:  "991c0fabc47c9bc3f94110137b364f23c9f1cc46a0acd680c7f554d63039f7b9"
    sha256 cellar: :any,                 sonoma:        "32faef4740ea692d32d316e2b5f87e2b989274dfea7796f396d8e314e2e1e941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "118fdfe3d540b443edf3f3b1bb874b58d5855e11f4c13c93ceaa724a4f5a3ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a47d78a7cdc55924649eaa4987a062a0f84e00c0909d59d63303129e3d74cf"
  end

  depends_on "pkgconf" => :build
  depends_on "poppler"

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
