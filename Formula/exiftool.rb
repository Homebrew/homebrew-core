class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://exiftool.org/Image-ExifTool-12.15.tar.gz"
  sha256 "02e07fae4070c6bf7cdeb91075f783fea17c766b7caa23e6834e8bba424551b9"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://exiftool.org/history.html"
    regex(/production release is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "63ec4f485ba5c8e96fdd1814da833cedb7f9707c654c4167cb4d22b3205414b6" => :big_sur
    sha256 "2093b487fe4738a03117ee7c2e7b7771d6a5b6b74da43e7b321ae2c5ff38fc79" => :arm64_big_sur
    sha256 "94e6bea5ede141fec762e7c7e06e1434d84b90695388cf269787ae77ece01cda" => :catalina
    sha256 "94e6bea5ede141fec762e7c7e06e1434d84b90695388cf269787ae77ece01cda" => :mojave
    sha256 "b7aa0c2aa1d2e0e1d2eab87c16c180153f62715e780f31a83f2f081d8f91b620" => :high_sierra
  end

  def install
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
