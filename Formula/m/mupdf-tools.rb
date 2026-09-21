class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.28.4-source.tar.gz"
  sha256 "2d97e043a616f96b148657c9c3d81ad71c4bd2052c59a2a3315ad842599340f9"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "96e80f7f958c595c3b1bd23d677b053ee81e6eaa701b5ed985c9538ab76f8c28"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "822f4ec6bb198c4acce21cac9a6c37e1443e22b6b2962f9a97170dbc4ca974a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b26433f13aee5f60d8e7d784d6d9d8caa5ca2158864e9841ef9f2549b3ec6f69"
    sha256 cellar: :any,                 arm64_linux:       "570c2b3917d2f2f88ebe512cf3017d68f5dc98fd214966938031b95676e25aa3"
    sha256 cellar: :any,                 x86_64_linux:      "1ef200db6c705d3995823d0b0203bdf4b968f22a9fdf79eea076eb708dc9aeb4"
  end

  conflicts_with "mupdf", because: "mupdf and mupdf-tools install the same binaries"

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "HAVE_GLUT=no",
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
