class Bersihkan < Formula
  desc "Hapus node_modules, .next, dist, build & cache framework secara rekursif"
  homepage "https://github.com/dankerizer/bersihkan"
  url "https://github.com/dankerizer/bersihkan/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "c4f7424353886b8717acae7a24dc330150f9af3d0c814b1c7d61eae44663a5c6"
  license "Apache-2.0"

  def install
    bin.install "bersihkan"
  end

  test do
    assert_match "Usage: bersihkan", shell_output("#{bin}/bersihkan --help")
  end
end
