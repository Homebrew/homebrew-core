class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.2.1.tar.bz2"
  sha256 "8f9741399b4b184ba28698c0fd7722638e79abac8e6c27eb526cc52b11ee0a1c"

  bottle do
    sha256 "73e85a79e9b7a8a4f07cb90a6581a124fd805f78b7206857aed3078bb90b90a8" => :mojave
    sha256 "41593cd4180688b27f6ab883530957720570df5eb3ff0fa5086981deaa9f9b60" => :high_sierra
    sha256 "3889ffe9662bfcbd7cffaf970874d2e49060ca6fd04ceb81b4c980c770547a08" => :sierra
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
