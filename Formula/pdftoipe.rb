class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.1.tar.gz"
  sha256 "b45a7d6bec339e878717bd273c32c7957e2d4d87c57e117e772ee3dd3231d7aa"
  revision 1

  bottle do
    cellar :any
    sha256 "4a04c9219dc9113a39ba33ddacd28768d139d86c59ee6ddbc87c86188956797e" => :mojave
    sha256 "95061176fb7818c898729baf87589497f068c9bccb0584d307ba85a50cb0ce47" => :high_sierra
    sha256 "f7dd43fd6d2883a5195d08f9a371749657107315f190a14bf063952bf12cfc20" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  # https://github.com/otfried/ipe-tools/pull/30
  # Should be safe to remove on next release but check if merged.
  patch do
    url "https://github.com/otfried/ipe-tools/pull/30.patch?full_index=1"
    sha256 "ac7f9945f12ff11a3ae41e368cb439aeac1e9ff3e81907568b39c3752959288c"
  end

  needs :cxx11

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
    assert_match "Homebrew test.</text>", File.read("test.ipe")
  end
end
