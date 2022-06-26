class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.20.0-source.tar.lz"
  sha256 "68dbb1cf5e31603380ce3f1c7f6c431ad442fa735d048700f50ab4de4c3b0f82"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c493f236e0af774afb966352a023b66059d75a54af20865f1b1d67f33ae8cd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc151c307061049300371337f1c41236635882c73597c03b356f6d67072d3d60"
    sha256 cellar: :any_skip_relocation, monterey:       "27bc185ebee2d76d295216e52a599db3893dd132301edc9ab5accadb5eb7d08d"
    sha256 cellar: :any_skip_relocation, big_sur:        "14d1754e20b71d62969e76a309be0fc11e592a493b255124176cc2492b2eeef7"
    sha256 cellar: :any_skip_relocation, catalina:       "f6b8527dd26ce2cecc837b7498a3a6186ae8ed323a9896de2f7bd016066e28e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d9e929ee015f6ac47b28964af03bbbecbcbd842f7cec9deea7f2562acc1a80"
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
