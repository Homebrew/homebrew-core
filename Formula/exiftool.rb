class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://exiftool.org/Image-ExifTool-12.26.tar.gz"
  sha256 "ed9f3285e263636c713ab52fcfb55cbcf4becd6c6e04bda410c8f240996ece9e"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d3a2f7e157086b5b36dd06a56e7d66692a11a8fa605e978ca4dea81809c8f00c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4d2164b47c21c2bc512a51e356350acd2e3c3eab476625678772ca20c4290a30"
    sha256 cellar: :any_skip_relocation, catalina:      "dcecf0acae250788ce5a32aec3e45a11a45af51a92109f78a560b6d896cc21a7"
    sha256 cellar: :any_skip_relocation, mojave:        "dcecf0acae250788ce5a32aec3e45a11a45af51a92109f78a560b6d896cc21a7"
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
