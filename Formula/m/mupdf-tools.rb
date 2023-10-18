class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.22.2-source.tar.gz"
  sha256 "54c66af4e6ef8cea9867cc0320ef925d561b42919ea0d4f89db5c9ef485bbeb7"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    formula "mupdf"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a7a431a92be58703a62c40c2372613f4833c2d3ac39b41adec18c29fede2ccc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b19863b811ce653ab0a37118372bedc943e820bbc64e70748b845bcd94b6e0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06192c4b527392269aff525bd821aff5742472921a9160a18bce81001cd239b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f27a11d3df7e2f035782acafec0af2819eb23628093fda55e2cb33e8fb87400e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac5cdbe30d5a522d558ec00e8a844d90533fbf10b9ac3ca13cd20109a608333c"
    sha256 cellar: :any_skip_relocation, ventura:        "f2b0e382df9aa751731f9f7df207d76c778c6e4e9135bb0a2c3c0bebdade2764"
    sha256 cellar: :any_skip_relocation, monterey:       "5a2b5d1d4b7669c42b7539ee838fe21549bfef18a91306b6e5793bcf667ee94b"
    sha256 cellar: :any_skip_relocation, big_sur:        "56db5863af955f42fa695222b97b1d146c55fa83482763a7c04c48430f721f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab9a80f8e5d00b99ddd97f07f198eb014f9ce252917bfa90c87f279a5fb953a7"
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
