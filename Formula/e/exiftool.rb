class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-12.60.tar.gz"
  mirror "https://exiftool.org/Image-ExifTool-12.60.tar.gz"
  sha256 "73dbe06d004c31082a56e78d7f246f2bb0002fbb1835447bc32a2b076f3d32ad"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cc5135fce9776fdf80db222c046fbc3ac47927a4379263ab28ccd60ccc84718"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a969e56b973c0d579c9e5bf0e0a8b18e67dd4f4430ea55874a53f8a073b1c2aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a969e56b973c0d579c9e5bf0e0a8b18e67dd4f4430ea55874a53f8a073b1c2aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6971f757e7d376474c821f30747fc9ec8d5b80437c0838e31967167e2f94a6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c62c1265ac44c8fa034f726d1a328416ea958302c8013fa253c0bb7b7815afa"
    sha256 cellar: :any_skip_relocation, ventura:        "7530b6e640f91294c223c2e97722145d91feea0917a6716daeee2cc5b888c1ae"
    sha256 cellar: :any_skip_relocation, monterey:       "7530b6e640f91294c223c2e97722145d91feea0917a6716daeee2cc5b888c1ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ac32b1e64ec5de6a8d5f9b87d62424056c8024571f7219e59f8699abf72255d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7960fb7ee4a8d1e6729425aee6fd27d742913e18985925c90d32667761ea602"
  end

  uses_from_macos "perl"

  def install
    # Enable large file support
    # https://exiftool.org/forum/index.php?topic=3916.msg18182#msg18182
    inreplace "lib/Image/ExifTool.pm", "LargeFileSupport => undef", "LargeFileSupport => 1"

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
