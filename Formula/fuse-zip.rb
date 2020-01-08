class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.7.0.tar.gz"
  sha256 "47306bab2b8b0db8ca6fac01833ccfb4394ddae1943ab2e7020b1bdbb210410b"
  head "https://bitbucket.org/agalanin/fuse-zip", :using => :hg

  bottle do
    cellar :any
    sha256 "3114b95376750564e24523622225a6aa98642f5127f2ac4f20d96a0a7d6865d1" => :catalina
    sha256 "3c3cc8b458faa125328582313df31efc6124da75a6a80e8b1a165b95d654e702" => :mojave
    sha256 "a0bd93e260a4cfa4138b5612be786695a30f1958528453f9ff3a62b795381671" => :high_sierra
    sha256 "0ec6b8c0e878898a539b101a0a56a21f6e2b962645fe35d7fe5a6a0486018066" => :sierra
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
