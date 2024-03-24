class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://exiftool.org/Image-ExifTool-12.80.tar.gz"
  sha256 "93d5229d6cb2fbe8064932bd1f53e1b7cd451f8843cc6eee6520528cb2d57906"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eaefac7e07b3e99c42d2aa0a99c8e78355c6d6a874245445de60d45c846febd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c98ed3b14a4d1c66cdb7c19b21fab826ce4c53df12e7a02a51f093f342e7c3b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c98ed3b14a4d1c66cdb7c19b21fab826ce4c53df12e7a02a51f093f342e7c3b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7518674545b5024eb61598e5597c0a42a3eec16bebe249c5ac00de773a45169"
    sha256 cellar: :any_skip_relocation, ventura:        "3a9703e2864c0e897286d4bb8d77d63612ca50fcec2c61e809c19838acb60474"
    sha256 cellar: :any_skip_relocation, monterey:       "3a9703e2864c0e897286d4bb8d77d63612ca50fcec2c61e809c19838acb60474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ef54fe0dfd9c6b794a61a269cd1599b58a79851f74c4369fbb33f1737f813c"
  end

  uses_from_macos "perl"

  def install
    # Enable large file support
    # https://exiftool.org/forum/index.php?topic=3916.msg18182#msg18182
    inreplace "lib/Image/ExifTool.pm", "'LargeFileSupport', undef", "'LargeFileSupport', 1"

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
