class Colormake < Formula
  desc "Wrapper around make to colorize the output"
  homepage "https://github.com/pagekite/Colormake"
  url "https://github.com/pagekite/Colormake/archive/0.9.20140503.tar.gz"
  sha256 "a3f9fae9a455ac96be1cce0371b28bda33a9af73b06fa8e4329aa2f693d68d22"
  license "GPL-2.0"
  head "https://github.com/pagekite/Colormake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0022e24dd1386f086be55a80bdcd0b7de7c2871995a4980f18db436c69dc4c63"
  end

  def install
    inreplace "colormake", "colormake.pl", "#{libexec}/colormake.pl"

    # Prefers symlinks than the original duplicate files
    File.unlink "colormake-short", "clmake", "clmake-short"
    File.symlink "colormake", "colormake-short"
    File.symlink "colormake", "clmake"
    File.symlink "colormake", "clmake-short"

    # Adds missing clmake.1 referenced in colormake.1 itself
    File.symlink "colormake.1", "clmake.1"

    # Installs auxiliary script, commands and mans
    libexec.install "colormake.pl"
    bin.install "colormake", "clmake", "colormake-short", "clmake-short"
    man1.install "colormake.1", "clmake.1"
  end

  test do
    (testpath/"Makefile").write("all:\n\techo Hello World!\n")
    assert_match "Hello World!", shell_output("#{bin}/colormake")
  end
end
