class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.27.2-source.tar.gz"
  sha256 "553867b135303dc4c25ab67c5f234d8e900a0e36e66e8484d99adc05fe1e8737"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97ad945f8b2bdf50c58442500597e7ab2ba18241af475df0773663072a7dcba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a139a93bbc5f35c9aae74b9995061a17cfeba1f63d86a1446d4e946344a6a59d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "288f35d6e41c08fef341a1a48a59d087a6154cedefed9ec820600502696f51b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "937be5eac62e8ecfd52d4748f7fb08c9a17cd0516cd59e3a6f3a8b851b0086cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f387c3ce63781f1db96a2d839748c8e7611b10a0232c95690d9de1bb81d2f2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb2e08cc4dbc91859d92cf84be6f8b871dab663ef5e5f3076966a5d1694bd0ae"
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
