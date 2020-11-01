class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.18.0-source.tar.xz"
  sha256 "592d4f6c0fba41bb954eb1a41616661b62b134d5b383e33bd45a081af5d4a59a"
  license "AGPL-3.0"
  head "https://git.ghostscript.com/mupdf.git"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c781037e13df1edd80ab97d715bf087f8ed1011016804123fcae03bc4e20cf14" => :catalina
    sha256 "c487a3e37a7004cfe63cc617db030d15199924d68eeec75d7c2f445448457d81" => :mojave
    sha256 "21389eb838991da63ebd3bb5903ce83c001d716ed192c38c0a14ae3939f758a8" => :high_sierra
  end

  depends_on :x11

  conflicts_with "mupdf-tools",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
