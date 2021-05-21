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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8eead0c1a0eb9987e9ff1c113f081a007b540d242c0f01e378bd58d6bfbe336f"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc42c22f10a9a50e5bdc051c7ea5f5b1ac91ebe388e82d47cdfb17390afc2c9f"
    sha256 cellar: :any_skip_relocation, catalina:      "417bf7b2283920446243141a671a8d8af58ccf817f69f3cf06cbd59f20869f00"
    sha256 cellar: :any_skip_relocation, mojave:        "417bf7b2283920446243141a671a8d8af58ccf817f69f3cf06cbd59f20869f00"
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
