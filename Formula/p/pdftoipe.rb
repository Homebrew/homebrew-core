class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.2.tar.gz"
  sha256 "c8de0dc7eb8fa959c96539fb19ebfb8e16f459e9b4ef9259aeb30b76072cd083"
  license "GPL-2.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4dcb5dc4436aba0dd0f54f346fbcef430ab8e20f3dc0abc27ce002e309181a19"
    sha256 cellar: :any, arm64_sequoia: "8546e4a4a9c29f23542eeb51f892060764810a79d928fd0dd5713fa55830bea3"
    sha256 cellar: :any, arm64_sonoma:  "ef8d03e71fbdbef5ebc3cde1edaa86743014e7f7041127b1af99023ae8a18c67"
    sha256 cellar: :any, sonoma:        "67dc067c0af6daf494e46362e0df65da3c7706b6bc2c3b9d685877c3857b39ae"
    sha256 cellar: :any, arm64_linux:   "3573c890825742130bc8dc0125967a4ed0fb07c4509d4165c05ad3b0c553382a"
    sha256 cellar: :any, x86_64_linux:  "139cd808f31309b8b785d177b1e633f573cd53e299385e853ba2f2c04c426180"
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
