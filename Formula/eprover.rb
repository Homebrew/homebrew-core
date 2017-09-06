class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "http://eprover.org"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.0/E.tgz"
  sha256 "ebd911cb3a8b43019f666ffde10b28ca8e0871ab401ce88d1b9ba276c5c8bcf6"

  bottle do
    cellar :any_skip_relocation
    sha256 "fffcc75e400937600fd2c059ecb5427476b216af5c56249c756400de4906885b" => :sierra
    sha256 "8d3dd0289c6f77d68dc2e1c9f06c039e106f2b6e324788315815a8c37b433e9c" => :el_capitan
    sha256 "6d13db7618b7a1d3e567165000a81d34384941c0f3de51177cf7b2a9b8f39ce7" => :yosemite
  end

  def install
    inreplace ["PROVER/eproof", "PROVER/eproof_ram"], "EXECPATH=.",
                                                      "EXECPATH=#{bin}"
    system "./configure", "--bindir=#{bin}", "--man-prefix=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/eproof"
  end
end
