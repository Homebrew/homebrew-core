class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.8.2/dar-2.8.2.tar.gz"
  sha256 "6f3a851cfdab15331d7663d91c22c855f7982a7ddb76894bf5e060fef25f71e7"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "bd64d352240df858a43850775b44695bb04f3a5495a410a3d6c5ef09aa48ad30"
    sha256 arm64_sequoia: "112167f8ac4e277a551b43c67fbda193b18e7afaf55604b320b27b85ffdf8ac3"
    sha256 arm64_sonoma:  "41801daa7be9c6d7e4383888e47578121df6bd386e8785c1da0f1ca52c926f25"
    sha256 sonoma:        "4a3b332f3325fdb0c71d65cc841dafd74ca334b325abe0f38568ca229d62e1e6"
    sha256 arm64_linux:   "7fc2472b226072697c61c65d0fb9690889b6563781ff76d5c3bfc5694f5ca6c2"
    sha256 x86_64_linux:  "f7abd5c8142851aed4feb2611f9d918e5bc5f9f2657c6451a3a8d5c47a63bf42"
  end

  depends_on "argon2"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz"
  depends_on "zstd"
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-dependency-tracking",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    mkdir "Library"
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
