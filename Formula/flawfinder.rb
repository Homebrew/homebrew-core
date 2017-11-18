class Flawfinder < Formula
  desc "Examines code and reports possible security weaknesses"
  homepage "https://www.dwheeler.com/flawfinder/"
  url "https://www.dwheeler.com/flawfinder/flawfinder-2.0.4.tar.gz"
  sha256 "43ffe3bd19cafbc4f24c53c6d80810297ebfbf9a72b693e58e59775813ee66ec"

  head "https://git.code.sf.net/p/flawfinder/code.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34e122b49623af2d7526018ea3905c716ebda6f42c08f0a96183091bbfd7ff99" => :high_sierra
    sha256 "bd4528ceb62ee1e1579de9f4d3465e2423052fb6e9aa2fdd8ebeb775de538601" => :sierra
    sha256 "bd4528ceb62ee1e1579de9f4d3465e2423052fb6e9aa2fdd8ebeb775de538601" => :el_capitan
    sha256 "bd4528ceb62ee1e1579de9f4d3465e2423052fb6e9aa2fdd8ebeb775de538601" => :yosemite
  end

  resource "flaws" do
    url "https://www.dwheeler.com/flawfinder/test.c"
    sha256 "4a9687a091b87eed864d3e35a864146a85a3467eb2ae0800a72e330496f0aec3"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource("flaws").stage do
      assert_match "Hits = 36",
                   shell_output("#{bin}/flawfinder test.c")
    end
  end
end
