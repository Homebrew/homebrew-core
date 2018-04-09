class BmapTools < Formula
  desc "Tool to flash image files to block devices using the block map"
  homepage "https://github.com/intel/bmap-tools"
  url "https://github.com/intel/bmap-tools/archive/v3.4.tar.gz"
  sha256 "483c5dd9589920b5bdec85d4cdbe150adb3ca404d205504f85c0fb03edc69c2a"

  depends_on "python"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "#{bin}/bmaptool", "--version"
  end
end
