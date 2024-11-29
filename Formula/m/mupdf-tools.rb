class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.25.0-source.tar.gz"
  sha256 "5493de830ab506b1c3bc8f5d670aa1a9f4ada9a959a4cc36cb7b4a3c12812074"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "270bd1ed54dddb6fbc299fef862d350d5274fd1f9e9105c0c86fa0f3688d0f4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca3271ca98d4e1fe749eb19e60f2a01c3f44e01f523ecf547fe0f63e7211e896"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d1de78ce7c58feb96763e693e6293437df751b6a6a317d554ecffa602250c85"
    sha256 cellar: :any_skip_relocation, sonoma:        "37ac86cf54a7a9f4b9c98b2f9444a722c901e93b3f322d94babc5a4df2129065"
    sha256 cellar: :any_skip_relocation, ventura:       "035d0e683dcdd1e80017790f3d880a43512695a2cf5d22da99f336a8480bf5c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88b4da3d19034335c332891adf602228f88b1873e0b577009e5e8ac1b66fb869"
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
