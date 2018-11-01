class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.1.tar.gz"
  sha256 "b45a7d6bec339e878717bd273c32c7957e2d4d87c57e117e772ee3dd3231d7aa"
  revision 2

  bottle do
    cellar :any
    sha256 "bb6c9f9614cb9d09cc3641118f627ce21dc4e4b35c22b139c3437e5e4231e917" => :mojave
    sha256 "4b8af712c6d8bdae593f60b03dfc6abaa0205013b9470376c519b6552ebddf52" => :high_sierra
    sha256 "89642035b0968b03bbac12d40a0b14b00caef43590e4f3f3311ca07715997a34" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  # no release was published after PR 30 so apply commit as patch
  patch do
    url "https://github.com/otfried/ipe-tools/commit/fe6cfdb6.diff?full_index=1"
    sha256 "b6f74b1e491c1d7290bc448ebf8ed30f4734eb290231182ecacb7896692080d5"
  end

  # https://github.com/otfried/ipe-tools/pull/31
  # Should be safe to remove on next release but check if merged.
  patch do
    url "https://github.com/otfried/ipe-tools/pull/31.patch?full_index=1"
    sha256 "2becf3ebd7078abe4947486f90cbf36b42e8c9676bd46c7707084a53df23e47b"
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
