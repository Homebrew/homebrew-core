class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.19.0-source.tar.xz"
  sha256 "38f39943e408d60a3e7d6c2fca0d705163540ca24d65682d4426dc6f1fee28c5"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9734ee8a290ca8bdfb681e9c4dbc5f72b4872ebfa1a4e64b7058e2966ca81d15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96319126ac01121c09cb766e69f068ce8cdc1e6f1bad689a8f06ff8be42c6a42"
    sha256 cellar: :any_skip_relocation, monterey:       "51fec922010e9994b5fba30fd51c9ba1ca7200fee2e4988c368b5e855f559dcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "f18d6bf6297215b02ec8ba38eaa14a6454ca0c14c87b8639165bb5234242bde3"
    sha256 cellar: :any_skip_relocation, catalina:       "e62ce50b62eae2126a1db2b6e2a0bda1ecc703fc4b7128b1b0e09bdf4550f61e"
    sha256 cellar: :any_skip_relocation, mojave:         "bf252482b840116b1228b35444e85b405bcf6325dcb18be88e5b02c2c91df5c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1c7257264ecf7e42c310fc98a5b1b0da8f781461bd26f893794f11200a5ed48"
  end

  conflicts_with "mupdf",
    because: "mupdf and mupdf-tools install the same binaries"

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
