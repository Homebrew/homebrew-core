class Netris < Formula
  desc "Networked variant of tetris"
  homepage "https://web.archive.org/web/20071223041235/http://www.netris.be/"
  url "ftp://ftp.netris.org/pub/netris/netris-0.52.tar.gz"
  mirror "http://ftp.de.debian.org/debian/pool/main/n/netris/netris_0.52.orig.tar.gz"
  sha256 "8bc770ebb2c3ead1611ca7a1a2f3d833e169536c78d53b3fcf49381164ee9706"

  bottle do
    cellar :any_skip_relocation
    sha256 "f884ada9bc59b53601b77b93e1b0b87e25dff13c7fbf5f078c309c08af9495c6" => :el_capitan
    sha256 "5c62fe0fa8814eabf4689098111f3c67f413295f1200e1b67971d699ed3adc82" => :yosemite
    sha256 "0f3ddd592b107ba5526d0de0a02ebc46f93ce9d069d7558d9104f56fe1ad6722" => :mavericks
  end

  # Debian has been applying fixes and security patches, so let's re-use their work.
  # Also fixes case of "TERM=xterm-color256" which otherwise segfaults.
  patch do
    url "http://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/01_multi-games-with-scoring"
    sha256 "5d5182afc06fbb6d011edfaa0c12e88425884019372f95faee563b760d03e556"
  end

  patch do
    url "http://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/02_line-count-patch"
    sha256 "c31de57729cfde1ec72e49fd0ee1984cfffc179eb3d16b1268853e14e827b71f"
  end

  patch do
    url "http://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/03_staircase-effect-fix"
    sha256 "df17bd23186c3d0379d298ac2e526ff40c7cdcebbe174c2bf2f08aa067abb4c7"
  end

  patch do
    url "http://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/04_robot-close-fixup"
    sha256 "8c79a8925357b57b07d4afa8a2ef048528f4ca19e25851637fd6f20f93ea7ae4"
  end

  patch do
    url "http://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/05_init-static-vars"
    sha256 "5b057390f6736c0d5c1d2b149c6550fb322358544641dc89d358c4c275a17724"
  end

  patch do
    url "http://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/06_curses.c-include-term.h"
    sha256 "9f0b631dcfcf2114ea1c70a599df401aafa21fb73423fa98783d01ac9a0845dc"
  end

  patch do
    url "http://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/07_curses.c-include-time.h"
    sha256 "b53bd8af4f09661ed9030baf52456595f3b4149966c2e3111c91305957a94a52"
  end

  patch do
    url "http://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/08_various-fixes"
    sha256 "8c9f709c115d8acf4af04e6dd60d75f2c7ecda2f9708aca2a2848966ec6999db"
  end

  patch do
    url "http://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/09_ipv6"
    sha256 "cf6c216cd4381a82945b441e2ad659120643126f52a89f745a9692fc708e8261"
  end

  patch do
    url "http://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/10_fix-memory-leak"
    sha256 "380566f670b90585943a2f3c69fdb83bae04d0e62cc457bb8d7558f393f6b874"
  end

  def install
    system "sh", "Configure"
    system "make"
    bin.install "netris"
  end

  test do
    assert_match "Netris version #{version}", shell_output("#{bin}/netris -H 2>&1")
  end
end
