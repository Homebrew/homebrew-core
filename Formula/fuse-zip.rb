class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.7.0.tar.gz"
  sha256 "47306bab2b8b0db8ca6fac01833ccfb4394ddae1943ab2e7020b1bdbb210410b"
  head "https://bitbucket.org/agalanin/fuse-zip", :using => :hg

  bottle do
    cellar :any
    sha256 "f368e76466c6a341d2f08876d9c5c7d523db0cc84b1a4641457d02bc796fc4c3" => :catalina
    sha256 "8aa19497fa708322ec386d9578ba0d323620bc4c26a9d257f9cbd25140aac908" => :mojave
    sha256 "ffedaf1ee44691c491f2b0ab134cd97263ce27bb9ec110874c23af4bdcfd18cb" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"
  depends_on :osxfuse

  def install
    # upstream issue: https://bitbucket.org/agalanin/fuse-zip/issues/66/cannot-build-fuze-zip-070-on-mac-osx
    inreplace "lib/extraField.cpp", "#include <sys/sysmacros.h>", ""
    inreplace "lib/fuse-zip.cpp", "stbuf->st_atim", "stbuf->st_atimespec"
    inreplace "lib/fuse-zip.cpp", "stbuf->st_mtim", "stbuf->st_mtimespec"
    inreplace "lib/fuse-zip.cpp", "stbuf->st_ctim", "stbuf->st_ctimespec"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system bin/"fuse-zip", "--help"
  end
end
