class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.5/E.tgz"
  sha256 "3a72cb5bcf24899134c84cb6c797c699d8d7ddfad0de7b5b654581bb17b3c814"

  bottle do
    cellar :any_skip_relocation
    sha256 "224dffbf0f507dd756b45f8ab9f06ec65e963ecfeeea69dcf72e76cc95bf760d" => :catalina
    sha256 "598fb6477f28822a593fe6c0fb218b4e70140ba44f6cd21feb6c0381c0b64641" => :mojave
    sha256 "9b2ece8fa609748d06a102d398c7315ab09c0da9af2d8b17daff11cb634767f6" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/eprover", "--help"
  end
end
