class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "http://eprover.org"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.0/E.tgz"
  sha256 "ebd911cb3a8b43019f666ffde10b28ca8e0871ab401ce88d1b9ba276c5c8bcf6"

  bottle do
    cellar :any_skip_relocation
    sha256 "28c7ee291eeb3860eb5dd1ec6cad9a33317b94588d4a90add58df12ea5f00dae" => :sierra
    sha256 "396ff4a7c412a5aa773f4df990611e27bd7d7ad5e4b297f9da3afa29cc2271ba" => :el_capitan
    sha256 "f698ea516f874623f22a6a87335b0881b0014e8bd1811f213b81a2bdd32f6f14" => :yosemite
    sha256 "0a5a1d15a59ec5921c3416de25df8e9fd518604e761396df3612bd587cdc00cf" => :mavericks
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
