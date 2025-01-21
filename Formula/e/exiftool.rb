class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-13.10.tar.gz"
  mirror "https://exiftool.org/Image-ExifTool-13.10.tar.gz"
  sha256 "d15bae18b6ea205869f3fc815cbc35af9022a24506bb540d8cb2e85b7795b600"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29fd8dbeda720f5d00dc1bdc834a3649a76ac520129cfb175edc074e39de30fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29fd8dbeda720f5d00dc1bdc834a3649a76ac520129cfb175edc074e39de30fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af264f92e9f7a49f0fe0fd2223c2bb515b3624b95adbe07f34d38d3df0842e58"
    sha256 cellar: :any_skip_relocation, sonoma:        "154a40158762db56b0f8644e2afe265476191a3907450734b7abad6824384075"
    sha256 cellar: :any_skip_relocation, ventura:       "28df6e34d8bf602c5facaadd5efe85d7ca8b67eb5c2b2a7ca58d619868e01a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55bfc592867a88920fdb6687a5d6b83c4b842a7a4f09d01490c7156641cb245"
  end

  uses_from_macos "perl"

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "unshift @INC, $incDir;", "unshift @INC, \"#{libexec}/lib\";"

    system "perl", "Makefile.PL"
    system "make", "all"
    libexec.install "lib"
    bin.install "exiftool"
    doc.install Dir["html/*"]
    man1.install "blib/man1/exiftool.1"
    man3.install Dir["blib/man3/*"]
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end
