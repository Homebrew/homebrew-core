class Glyph < Formula
  desc "Converts images/video to ASCII art"
  homepage "https://github.com/seatedro/glyph"
  url "https://github.com/seatedro/glyph/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "7de7936a13b92b18240134bef64c006ab73988850a8776a1b276e22b73377f15"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_sequoia: "b02ed837b5d2195d730ce7ddcd189907ef6d39b2ca99b09deaefa38286e40525"
    sha256 cellar: :any, arm64_sonoma:  "2c9fecb839cda3e0125e815cc6c716ce02b483d5d533d69afa72867e6a23670b"
    sha256 cellar: :any, sonoma:        "99fd425ed184792fb3d3b37514bd00e90f6fac2b7d6f8c330144ba2ec1058ac1"
    sha256 cellar: :any, arm64_linux:   "15963411be783330cd38b39f8e25d4a6f62220a191afbfe9fe4ecbba20fa7512"
    sha256 cellar: :any, x86_64_linux:  "da53112573da11e6175dc4882e8d74a603e3e64c76d0c51c8d45f65439493096"
  end

  # Aligned to `zig@0.14` formula. Can be removed if upstream updates to newer Zig.
  deprecate! date: "2026-08-19", because: "does not build with Zig >= 0.15"
  disable! date: "2027-08-19", because: "does not build with Zig >= 0.15"

  depends_on "pkgconf" => :build
  depends_on "zig@0.14" => :build # https://github.com/seatedro/glyph/issues/32
  depends_on "ffmpeg"

  on_macos do
    depends_on maximum_macos: [:sequoia, :build] # TODO: remove with Zig 0.15+
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    system bin/"glyph", "-i", test_fixtures("test.png"), "-o", "png.txt"
    assert_path_exists "png.txt"

    system bin/"glyph", "-i", test_fixtures("test.jpg"), "-o", "jpg.txt"
    assert_path_exists "jpg.txt"
  end
end
