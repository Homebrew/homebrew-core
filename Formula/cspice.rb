class Cspice < Formula
  desc "Observation geometry system for robotic space science missions"
  homepage "https://naif.jpl.nasa.gov/naif/toolkit.html"
  url "https://naif.jpl.nasa.gov/pub/naif/toolkit/C/MacIntel_OSX_AppleC_64bit/packages/cspice.tar.Z"
  version "67"
  sha256 "6f4980445fee4d363dbce6f571819f4a248358d2c1bebca47e0743eedfe9935e"

  # The `stable` tarball is unversioned, so we have to identify the latest
  # version from text on the homepage.
  livecheck do
    url :homepage
    regex(/current SPICE Toolkit version is (?:<[^>]+?>)?N0*(\d+)/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a3e9574c472567a3814aed8f11bcc0874d6dc4ce2e1e867351e5668366d60a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27847bdbb741a1195069b815bef8bcbdbcbc183ab3b7034a83eb7854348d7f04"
    sha256 cellar: :any_skip_relocation, monterey:       "b6317d5408e0c56164299671a459ed55c3581a219b4e0b7c699c08fe6abbcb3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "081d234c0862319ab53275de9eb9f6e006d53afe43c63d53425bd089ea9b493c"
    sha256 cellar: :any_skip_relocation, catalina:       "900cfe839cf53dc03c1e227332d24849e55209a606dba515412ae74a955144f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c49763f72469907d773eef66b54ae8dce74c3df9f2f5dee29468de3ea9f0953"
  end

  on_linux do
    depends_on "tcsh"
  end

  conflicts_with "openhmd", because: "both install `simple` binaries"
  conflicts_with "libftdi0", because: "both install `simple` binaries"
  conflicts_with "enscript", because: "both install `states` binaries"

  def install
    # Use brewed csh on Linux because it is not installed in CI.
    unless OS.mac?
      Dir["src/*/*.csh"].each do |file|
        inreplace file, "/bin/csh", Formula["tcsh"].opt_bin/"csh"
      end
    end

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
