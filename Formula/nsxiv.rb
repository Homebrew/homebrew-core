class Nsxiv < Formula
  desc "Neo Simple X Image Viewer"
  homepage "https://github.com/nsxiv/nsxiv"
  url "https://github.com/nsxiv/nsxiv/archive/v28.tar.gz"
  sha256 "38047f60e51854363dd98fb7b3bc9f1cfa9b7d6f9e8788508b6f1e317328dd75"

  license "GPL-2.0-or-later"
  head "https://github.com/nsxiv/nsxiv.git", branch: "master"

  depends_on "giflib"
  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libx11"
  depends_on "libxft"

  def install
    system "make", "PREFIX=#{prefix}", "HAVE_INOTIFY=0",
                   "CPPFLAGS=-I#{Formula["freetype2"].opt_include}/freetype2",
                   "install"
  end

  test do
    assert_match "Error opening X display", shell_output("DISPLAY= #{bin}/nsxiv #{test_fixtures("test.png")} 2>&1", 1)
  end
end
