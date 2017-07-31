class Flawfinder < Formula
  desc "Examines code and reports possible security weaknesses"
  homepage "https://www.dwheeler.com/flawfinder/"
  url "https://www.dwheeler.com/flawfinder/flawfinder-2.0.0.tar.gz"
  mirror "https://downloads.sourceforge.net/project/flawfinder/flawfinder-2.0.0.tar.gz"
  sha256 "1dece3dd21017b92f6857033bc729db3cf7d7ba8b58088534ed360bde5d0644f"

  head "https://git.code.sf.net/p/flawfinder/code.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c480560a08ba8361768473bd48c8f3483434ff66f78b49fb4b62ff873a192e9" => :sierra
    sha256 "5c480560a08ba8361768473bd48c8f3483434ff66f78b49fb4b62ff873a192e9" => :el_capitan
    sha256 "5c480560a08ba8361768473bd48c8f3483434ff66f78b49fb4b62ff873a192e9" => :yosemite
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
