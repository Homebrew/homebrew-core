class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-12.30.tar.gz"
  mirror "https://exiftool.org/Image-ExifTool-12.30.tar.gz"
  sha256 "3be7cda70b471df589c75a4adbb71bae62e633022b0ba62585f3bcd91b35544f"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f15d7e3cbd2a3cb5b233798dce5a9fb51538c099f640b4d44cbbe8023dfca843"
    sha256 cellar: :any_skip_relocation, big_sur:       "8e727af23046739b711bd75afeec7ca4e5853b2a7999c7f972f3c4c0daab3c0a"
    sha256 cellar: :any_skip_relocation, catalina:      "336b0ba051cc4f11b07c2b307dc7199f973f8c5f10d2dd9a3fbd33bb7d707bf5"
    sha256 cellar: :any_skip_relocation, mojave:        "336b0ba051cc4f11b07c2b307dc7199f973f8c5f10d2dd9a3fbd33bb7d707bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "451d3581ac54e5b552b9ae6517e9e6d3d78f068e23ed0431200d6d9be814a2f8"
  end

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$1/lib", libexec/"lib"

    system "perl", "Makefile.PL"
    system "make", "all"
    libexec.install "lib"
    bin.install "exiftool"
    doc.install Dir["html/*"]
    suffix = ""
    on_linux do
      suffix = "p"
    end
    man1.install "blib/man1/exiftool.1#{suffix}"
    man3.install Dir["blib/man3/*"]
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end
