class ArchivemountNg < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://sr.ht/~nabijaczleweli/archivemount-ng/"
  url "https://git.sr.ht/~nabijaczleweli/archivemount-ng/archive/1a.tar.gz"
  version "1a"
  sha256 "ca8f77cd8621ecfc388106f4b725943d2a6119fc8e3b3ae5ce50a05cb894fe4d"
  license "LGPL-2.0-or-later" # excluding 0BSD which is for Makefile and test
  head "https://git.sr.ht/~nabijaczleweli/archivemount-ng", branch: "trunk"

  depends_on "pkgconf" => :build
  depends_on "libarchive"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    args = ["PREFIX=#{prefix}"]
    args << "VERSION=#{version}" if build.stable?
    system "make", "install", *args
    prefix.install "LICENSES/LGPL-2.0-or-later.txt"
  end

  test do
    (testpath/"mnt").mkpath
    tarball = test_fixtures("tarballs/testball2-0.1.tbz")
    assert_match "version #{version}", shell_output("#{bin}/archivemount --version")
    assert_match "fuse: device not found", shell_output("#{bin}/archivemount #{tarball} mnt 2>&1")
  end
end
