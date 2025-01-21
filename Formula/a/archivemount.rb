class Archivemount < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://github.com/cybernoid/archivemount"
  url "https://slackware.uk/~urchlay/src/archivemount-0.9.1.tar.gz"
  sha256 "c529b981cacb19541b48ddafdafb2ede47a40fcaf16c677c1e2cd198b159c5b3"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://raw.githubusercontent.com/cybernoid/archivemount/refs/heads/master/CHANGELOG"
    regex(/\*\s+v?(\d+(?:\.\d+)+)\s+/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, x86_64_linux: "238d9539e81cdafd6d74dee82438d06c4348b5570260102811a2a1362088527c"
  end

  depends_on "pkgconf" => :build
  depends_on "libarchive"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"archivemount", "--version"
  end
end
