class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.24.9-source.tar.gz"
  sha256 "0b446aa0eecc114e9969dccd70c9789358fccb6589a81d470dc941a0874da98a"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e673b47a69c996d24752ea83ae12a58ad9ffb95183541476026848ef191c5da6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c93714b24afacf71614427a33efa8f8b9a479d6e6e9f2a1674432c87e33231d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5e8880266c067ef1f7171de86bca55fc39448d9091156cc4ec5b44d7707e1cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1a3555dc2412292438a87965031375bd7d64b67b1f4dfd206ca229919c59a91"
    sha256 cellar: :any_skip_relocation, sonoma:         "d861e37240e8e9c050a931fb9cfc864cc4c688fbdabeff43bae0351104da2d94"
    sha256 cellar: :any_skip_relocation, ventura:        "932a2df63829b1c1893f8373743b6fa4fe9b7a95789c95cb1c6e86a49e587eed"
    sha256 cellar: :any_skip_relocation, monterey:       "58354687cee444b0a4897de4d2e4239f66abc69aea126adf6cb25726155922d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f403189a6f6c700ef51442e9b18996983d5788ca82a689688dd09ac7afc00a21"
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
