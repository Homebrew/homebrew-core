class Iphotoexport < Formula
  desc "Export and synchronize iPhoto library to a folder tree"
  homepage "https://code.google.com/archive/p/iphotoexport/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/iphotoexport/iphotoexport-1.6.4.zip"
  sha256 "85644b5be1541580a35f1ea6144d832267f1284ac3ca23fe9bcd9eda5aaea5d3"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b61d6e01dd01bc1ab24a32284ce269495beb77a6f516c8b30e5c86003b66333"
  end

  # Replaced by Phoshare app, which was discontinued on 2012-10-10.
  # The current version (1.6.4) is from 2010-05-15.
  deprecate! date: "2021-06-27", because: :deprecated_upstream

  depends_on "exiftool"

  def install
    # Change hardcoded exiftool path
    inreplace "tilutil/exiftool.py", "/usr/bin/exiftool", "exiftool"

    prefix.install Dir["*"]
    bin.install_symlink prefix/"iphotoexport.py" => "iphotoexport"
  end

  test do
    system "#{bin}/iphotoexport", "--help"
  end
end
