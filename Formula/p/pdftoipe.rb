class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.2.tar.gz"
  sha256 "c8de0dc7eb8fa959c96539fb19ebfb8e16f459e9b4ef9259aeb30b76072cd083"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "925ab674cfe54fa896be09d5955cbe34a8a6bd360d470f5b27138f6f54285f30"
    sha256 cellar: :any,                 arm64_sequoia: "239e474e57bde672ebd95ce5080707dd19f53657e0758fb793f5a3bddabc22f3"
    sha256 cellar: :any,                 arm64_sonoma:  "d678c4d7391400822f77932e1aec8c390f2bfe0319d23db8d873594a1ee37ec0"
    sha256 cellar: :any,                 sonoma:        "e86b1e00edbb1a724aa885127946f79546dbc249e22faff0404aa815f1c3105d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93193eb8c9f505cb67170d1f9ed201f1be0272256f4426c3b745f01d0d6c14e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6129577ea54ba9866d6a8bd8ef777fd1d8ed7c554f3dc994ebe5d01ec1500ec9"
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
