class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.26.6-source.tar.gz"
  sha256 "f6e5cd4ef93681776b79e388baa26e66c3a7e7439e91e0d7f3a01f9a89dec44d"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee4736a70f99ea8e9f38fffbf3088789d654c1d66fb376a6bef872517154a3cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc1664a1d1124137640bdb880ceff546784e03b67ae120d1200b9001dd08e400"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b1866304cbab3325b868a97587b50ff76fd3d8be3caf10d04060c91a3b7c8f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e96ff1dd3566822081161558915d9615cc55c8477cc87f84d9ddf32abf3cf5b"
    sha256 cellar: :any_skip_relocation, ventura:       "2db5735cbb45f71d747784e2d7c86be089529a6f4c17d0160f3d0d06da6ca628"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a065f6afaa5e7175ea6ac3333cc027588928ea353899a3c212717b3a41f413a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8d0bcd3b88ec439bd1d65ee47e464873180a15de705c19d816e21e27ca08825"
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
