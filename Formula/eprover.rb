class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.1/E.tgz"
  sha256 "f4d8b0316dfe670b636e85382d0d9802fe723b6e13c316497163a85fa54a09be"

  bottle do
    cellar :any_skip_relocation
    sha256 "695d0b85e575af8af73481ee2678cbfa7687b140a75d402234a2ddce6425bc9d" => :high_sierra
    sha256 "fffcc75e400937600fd2c059ecb5427476b216af5c56249c756400de4906885b" => :sierra
    sha256 "8d3dd0289c6f77d68dc2e1c9f06c039e106f2b6e324788315815a8c37b433e9c" => :el_capitan
    sha256 "6d13db7618b7a1d3e567165000a81d34384941c0f3de51177cf7b2a9b8f39ce7" => :yosemite
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
