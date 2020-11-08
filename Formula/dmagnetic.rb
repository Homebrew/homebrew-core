class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.27.tar.bz2"
  sha256 "ed6be4e1e3f1dd09dcf2b73ccd2ddd4c7630f4755b25883b38b2e99768559375"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4731f50eb5fb519c288b177211866aa5c9564c3128ccfd90cace9f17349f6ef" => :catalina
    sha256 "e3fb3df08f05eaef9fcfd093300312997523292bae8c9497e008b3404d122faf" => :mojave
    sha256 "c3d655f6787a40b59db97b491c3e057da87044f3a382debd00ec0bf61e528890" => :high_sierra
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    (share/"games/dMagnetic").install "testcode/minitest.mag", "testcode/minitest.gfx"
  end

  test do
    assert_match "ab9ec7787593e310ac4d8187db3f6cee", \
      shell_output("echo Hello | #{bin}/dMagnetic "\
        "-vmode none -vcols 300 -vrows 300 -vecho -sres 1024x768 "\
        "-mag #{share}/games/dMagnetic/minitest.mag "\
        "-gfx #{share}/games/dMagnetic/minitest.gfx "\
        "| md5").strip
  end
end
