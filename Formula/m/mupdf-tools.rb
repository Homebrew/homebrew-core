class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.26.9-source.tar.gz"
  sha256 "54ceeaab4a694526d9db7282431e62d3ff9b1ca52da0c5dbf0c82c9a43361a1d"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bd5b26076c71c98ad3d68cda9e74c3dc54c7fa5b36c44ca5efe21be7534541f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42096fcb248d3286c56dec80d6001b4b86d0d73efce1189f5f8d3928bd8ae515"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d50b135461c4a6cc2cd3616a37bf98286a41d938383da2d400188d47d5412b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7793af2cbd51144eb6575f46e77a76513426c19ad3e501cdcd266670a45ab1c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c804b7a7eac6ec888c4f576870f2c0977c16583514ad5780c35a2225b08e706d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8577192003c82c9d26153b3c1a7f90f43e3ec75c311b67586d0438d348f96458"
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
