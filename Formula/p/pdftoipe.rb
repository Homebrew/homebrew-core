class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15c58803438a27581f49a0454230e47309ce4f98962dcf4ce6d7ecc5f4d9a27e"
    sha256 cellar: :any,                 arm64_sonoma:  "eb33734aec3285ec8fb33e872b305a68769c581ca57b4f77185e81c6954d5f84"
    sha256 cellar: :any,                 arm64_ventura: "e4d854e8448b630b6806259f74b56c904c170f0e38e1a189ce6585cd150a2e08"
    sha256 cellar: :any,                 sonoma:        "1c24520839bb0e811dad8a90b370b3ae0a416415f60ab757499541201829b4e1"
    sha256 cellar: :any,                 ventura:       "03c83f23fb16c45986e2f22373e5847d21971fbacea16cb21c0264694ac5003a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5430c0096c66c5a7bf54d1d14fd4e3e68bd3284e23ea39f657b136af6f04219f"
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
