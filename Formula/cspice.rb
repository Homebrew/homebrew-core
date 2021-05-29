class Cspice < Formula
  desc "Observation geometry system for robotic space science missions"
  homepage "https://naif.jpl.nasa.gov/naif/toolkit.html"
  url "https://naif.jpl.nasa.gov/pub/naif/toolkit/C/MacIntel_OSX_AppleC_64bit/packages/cspice.tar.Z"
  version "66"
  sha256 "f5d48c4b0d558c5d71e8bf6fcdf135b0943210c1ff91f8191dfc447419a6b12e"

  # The `stable` tarball is unversioned, so we have to identify the latest
  # version from text on the homepage.
  livecheck do
    url :homepage
    regex(/current SPICE Toolkit version is (?:<[^>]+?>)?N0*(\d+)/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "a8674cfcd5ef55ec8061890728960dd910aa23533c2c4868e93915c77b6e5c8c"
    sha256 cellar: :any_skip_relocation, mojave:      "a08696e53b60d3255a28ca8c52fc6ba992d95f345f31dea6506a64227d10ceac"
    sha256 cellar: :any_skip_relocation, high_sierra: "dac29486067ad080407dfd76641a8902103ce333750d5e2c9723409806f2ab61"
    sha256 cellar: :any_skip_relocation, sierra:      "5ffb3eec6da9aa84ff58330734d024df9ea1378b1cc93365736b66d4315c47b9"
    sha256 cellar: :any_skip_relocation, el_capitan:  "ceec1738779c07c06bd21b5c81816fb66854b728a1a098fe5ac1f37a176ee32f"
    sha256 cellar: :any_skip_relocation, yosemite:    "ff72f9d54707e03e86016b286117528720134acd4f23bd6e6b4402c8cd4def73"
  end

  conflicts_with "openhmd", because: "both install `simple` binaries"
  conflicts_with "libftdi0", because: "both install `simple` binaries"
  conflicts_with "enscript", because: "both install `states` binaries"
  conflicts_with "fondu", because: "both install `tobin` binaries"

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
