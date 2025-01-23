class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.25.3-source.tar.gz"
  sha256 "b974d706a9680533d104b4112224c7bf3de93f27be7ca41b4bfb51552624f0a9"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca863958dac283c07ab920031bb57ab4af878abc85eafbb1c8c1691474236322"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f43b1175608b57f26bd720e62a33f19e6ddebb1b5b939639dc7ed4e6662afa70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7f15068771d48b0d88b32d7fb088598feefe473155995f61bace6c24014e0e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b843762d87f6e1d2d799f98eccd8dc64d56edbe08e9d6303445be64c18ca0cfa"
    sha256 cellar: :any_skip_relocation, ventura:       "8c56004057e84eded0818a98b4444593fdd2bd47ed3b11632dd1cc3004f2807a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d080a280a93f2ac3f6d7b51d3c3515e3d5068a2e16180db9339e74803f59d007"
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
