class Flawfinder < Formula
  desc "Examines code and reports possible security weaknesses"
  homepage "https://www.dwheeler.com/flawfinder/"
  url "https://www.dwheeler.com/flawfinder/flawfinder-2.0.2.tar.gz"
  mirror "https://downloads.sourceforge.net/project/flawfinder/flawfinder-2.0.2.tar.gz"
  sha256 "2ca96b106cbf6af495fe558e5111838c74cab0492e9b5d376f567b430e57052f"

  head "https://git.code.sf.net/p/flawfinder/code.git"

  bottle do
    cellar :any_skip_relocation
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
