class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-12.42.tar.gz"
  mirror "https://exiftool.org/Image-ExifTool-12.42.tar.gz"
  sha256 "31d805ed59f2114f19c569f8a2aaffb89fa211453733d2c650d843a3e46236df"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d262f00f8f26d69838dad118928276859984c4b69885c606cb3bcf7eee44452"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52deb0d5fdb3e25412439bdc3c0a9f0fd827e4d9903cb37d4a0e50be3963e4ad"
    sha256 cellar: :any_skip_relocation, monterey:       "b5087be17a279128ca05aafd3c2332dff4ccadbb3e13e808596b65a8b2a87b5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d1fd5bd75287ece6407d067a30a89886e1fcaefd42afa3f4d6ca07f2bb9c6e5"
    sha256 cellar: :any_skip_relocation, catalina:       "80da9ac3b1b54b839ff144a8cd35c0785e431bcd95c4aa437a3f8c82ac959e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "975e2a4b41e750db055cfd0e40c87fce2e49bd0cbef810ebc8e00a12e3e9f598"
  end

  uses_from_macos "perl"

  def install
    # Enable large file support
    # https://exiftool.org/forum/index.php?topic=3916.msg18182#msg18182
    inreplace "lib/Image/ExifTool.pm", "LargeFileSupport => undef", "LargeFileSupport => 1"

    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$1/lib", libexec/"lib"

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
