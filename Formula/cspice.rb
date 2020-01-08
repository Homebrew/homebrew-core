class Cspice < Formula
  desc "Observation geometry system for robotic space science missions"
  homepage "https://naif.jpl.nasa.gov/naif/toolkit.html"
  url "https://naif.jpl.nasa.gov/pub/naif/toolkit/C/MacIntel_OSX_AppleC_64bit/packages/cspice.tar.Z"
  mirror "https://dl.bintray.com/homebrew/mirror/cspice-66.tar.Z"
  version "66"
  sha256 "f5d48c4b0d558c5d71e8bf6fcdf135b0943210c1ff91f8191dfc447419a6b12e"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8674cfcd5ef55ec8061890728960dd910aa23533c2c4868e93915c77b6e5c8c" => :catalina
    sha256 "dac29486067ad080407dfd76641a8902103ce333750d5e2c9723409806f2ab61" => :high_sierra
    sha256 "5ffb3eec6da9aa84ff58330734d024df9ea1378b1cc93365736b66d4315c47b9" => :sierra
    sha256 "ceec1738779c07c06bd21b5c81816fb66854b728a1a098fe5ac1f37a176ee32f" => :el_capitan
    sha256 "ff72f9d54707e03e86016b286117528720134acd4f23bd6e6b4402c8cd4def73" => :yosemite
  end

  conflicts_with "openhmd", :because => "both install `simple` binaries"
  conflicts_with "libftdi0", :because => "both install `simple` binaries"
  conflicts_with "enscript", :because => "both install `states` binaries"
  conflicts_with "fondu", :because => "both install `tobin` binaries"

  def install
    rm_f Dir["lib/*"]
    rm_f Dir["exe/*"]
    system "csh", "makeall.csh"
    mv "exe", "bin"
    pkgshare.install "doc", "data"
    prefix.install "bin", "include", "lib"

    lib.install_symlink "cspice.a" => "libcspice.a"
    lib.install_symlink "csupport.a" => "libcsupport.a"
  end

  test do
    system "#{bin}/tobin", "#{pkgshare}/data/cook_01.tsp", "DELME"
  end
end
