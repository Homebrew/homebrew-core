class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/greyblake/crystal-icr"
  url "https://github.com/greyblake/crystal-icr/archive/v0.2.8.tar.gz"
  sha256 "5a235ee2f3065c6cf9479a7c32a11ba3d11f5e185d6c1458a97bd60eb11f88a3"

  depends_on "crystal-lang"
  depends_on "readline"

  def install
    system "make"
    bin.install "bin/icr"
  end

  test do
    assert_equal "icr version 0.2.8",
      shell_output("#{bin/"icr"} -v").split("\n").first
  end
end
