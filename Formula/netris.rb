class Netris < Formula
  desc "Networked variant of tetris"
  homepage "https://web.archive.org/web/20071223041235/www.netris.be/"
  url "https://deb.debian.org/debian/pool/main/n/netris/netris_0.52.orig.tar.gz"
  sha256 "8bc770ebb2c3ead1611ca7a1a2f3d833e169536c78d53b3fcf49381164ee9706"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "325a86274ce6276ebecbf44fd386861b02ca96a8aa982da845c21ba0932aca00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7b88fa79c440ed0dc4c971eb32197e9f88b34afbf50cd6d9e8929f2e03d7866"
    sha256 cellar: :any_skip_relocation, monterey:       "1cd2c848c2e5da61c99c8c2930c77f21e58aeb91fdf97c678392bdb34ca252ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f7c51618024abd332dafe7c9075896fdfefbd80819a4b0c42bf493637947bd2"
    sha256 cellar: :any_skip_relocation, catalina:       "41fc6feceffbce79c1bdac8c198d318b8a91c2e8ae099f068a8a21bf9344e038"
    sha256 cellar: :any_skip_relocation, mojave:         "25697a4b18177f5e976dd5510b68cac949a589a7c9abe2e2d148b930db0d1f89"
    sha256 cellar: :any_skip_relocation, high_sierra:    "2ba4eea757cc21504d1da74796a29fcd23264b5d735c0c6debe1083614c2d57a"
    sha256 cellar: :any_skip_relocation, sierra:         "4ac49c49b3d000fcb5c9161f4b217231e9bee9faf29d5e4e7fc9f5d8e10772ec"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0e793cab922cded47c3eccbf4e9ba8840a71f24830d7e01da8e2262d08d61c56"
    sha256 cellar: :any_skip_relocation, yosemite:       "1a1e54ff92dd1e8ecd745e149874071cb6e67662296c96d84538cf71b65b9bfe"
  end

  # Debian has been applying fixes and security patches, so let's re-use their work.
  # Also fixes case of "TERM=xterm-color256" which otherwise segfaults.
  patch do
    url "https://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/01_multi-games-with-scoring"
    sha256 "5d5182afc06fbb6d011edfaa0c12e88425884019372f95faee563b760d03e556"
  end

  patch do
    url "https://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/02_line-count-patch"
    sha256 "c31de57729cfde1ec72e49fd0ee1984cfffc179eb3d16b1268853e14e827b71f"
  end

  patch do
    url "https://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/03_staircase-effect-fix"
    sha256 "df17bd23186c3d0379d298ac2e526ff40c7cdcebbe174c2bf2f08aa067abb4c7"
  end

  patch do
    url "https://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/04_robot-close-fixup"
    sha256 "8c79a8925357b57b07d4afa8a2ef048528f4ca19e25851637fd6f20f93ea7ae4"
  end

  patch do
    url "https://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/05_init-static-vars"
    sha256 "5b057390f6736c0d5c1d2b149c6550fb322358544641dc89d358c4c275a17724"
  end

  patch do
    url "https://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/06_curses.c-include-term.h"
    sha256 "9f0b631dcfcf2114ea1c70a599df401aafa21fb73423fa98783d01ac9a0845dc"
  end

  patch do
    url "https://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/07_curses.c-include-time.h"
    sha256 "b53bd8af4f09661ed9030baf52456595f3b4149966c2e3111c91305957a94a52"
  end

  patch do
    url "https://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/08_various-fixes"
    sha256 "8c9f709c115d8acf4af04e6dd60d75f2c7ecda2f9708aca2a2848966ec6999db"
  end

  patch do
    url "https://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/09_ipv6"
    sha256 "cf6c216cd4381a82945b441e2ad659120643126f52a89f745a9692fc708e8261"
  end

  patch do
    url "https://git.deb.at/w/pkg/netris.git/blob_plain/90991bd0137a2510f93ec126a8642f48eb3738be:/debian/patches/10_fix-memory-leak"
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
