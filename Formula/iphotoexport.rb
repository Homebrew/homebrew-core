class Iphotoexport < Formula
  desc "Export and synchronize iPhoto library to a folder tree"
  homepage "https://code.google.com/archive/p/iphotoexport/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/iphotoexport/iphotoexport-1.6.4.zip"
  sha256 "85644b5be1541580a35f1ea6144d832267f1284ac3ca23fe9bcd9eda5aaea5d3"

  bottle :unneeded

  depends_on "exiftool"

  def install
    unzip_dir = "#{name}-#{version}"
    # Change hardcoded exiftool path
    inreplace "#{unzip_dir}/tilutil/exiftool.py", "/usr/bin/exiftool", "exiftool"

    prefix.install Dir["#{unzip_dir}/*"]
    bin.install_symlink prefix+"iphotoexport.py" => "iphotoexport"
  end

  test do
    system "#{bin}/iphotoexport", "--help"
  end
end
