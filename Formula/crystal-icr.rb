class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/greyblake/crystal-icr"
  url "https://github.com/greyblake/crystal-icr/archive/v0.2.8.tar.gz"
  sha256 "5a235ee2f3065c6cf9479a7c32a11ba3d11f5e185d6c1458a97bd60eb11f88a3"

  depends_on "crystal-lang"
  depends_on "readline"

  patch do
    url "https://github.com/greyblake/crystal-icr/commit/25a348bb.patch"
    sha256 "1ed507cdda3635c998e7613e0bb4d4172af73bd7b10431d341c3559e6c01ceb0"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal "icr version #{version}",
      shell_output("#{bin/"icr"} -v").lines.first
  end
end
