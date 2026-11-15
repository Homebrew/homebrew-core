class Archivemount < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://git.sr.ht/~nabijaczleweli/archivemount-ng"
  url "https://git.sr.ht/~nabijaczleweli/archivemount-ng/archive/1c.tar.gz"
  version "1c"
  sha256 "7bc489a1a77ce718c84b751a57779ded6bb192cf54f9cd0bf7bff2527cf98bfc"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_linux:  "1d624447a2e932adfb13c34cc558a7a71912a849aad2c2acb050e8957ad13f60"
    sha256 cellar: :any, x86_64_linux: "b86976cfadc9d17ba468dd34bdd482adb1104f201b4a279d9bdb651108e368ed"
  end

  depends_on "pkgconf" => :build
  depends_on "libarchive"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  deny_network_access!

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"archivemount", "--version"
  end
end
