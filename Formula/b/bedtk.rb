class Bedtk < Formula
  desc "Simple toolset for BED files"
  homepage "https://github.com/lh3/bedtk"
  url "https://github.com/lh3/bedtk/archive/refs/tags/v1.2.tar.gz"
  sha256 "c0e1f454337dbd531659662ccce6c35831e7eec75ddf7b7751390b869e6ce9f0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd6687dd9bad59b278142fd479824d407c6a905c24626b97f1539ad7eeb5caa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74a65feea27bbbde2c15445ad3f9c3c2b2a519b3128e789356daf7ed0700ebeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "662b0278c4f58613e36036346bf93855ae5ddc59659bad93b6eea2e8dcd67083"
    sha256 cellar: :any_skip_relocation, sonoma:        "149a91b7c3a8bff8b66d0cf23407ea2c1b9acb261cadb85e73ab887b7426d6e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "634e3fce5cdedd155c531a2d98e327bc7312d9553236fbefa771eb05499c8d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96e41ae22f6efd0be9dd6f7b8facec49bcef5f9f563dc73420ca7631904850a2"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make"
    bin.install "bedtk"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    system bin/"bedtk", "flt", "test-anno.bed.gz", "test-iso.bed.gz"
  end
end
