class Brogue < Formula
  desc "Roguelike game"
  homepage "https://sites.google.com/site/broguegame/"
  # The OS X version doesn't contain a Makefile, so we
  # need to download the Linux version
  url "https://sites.google.com/site/broguegame/brogue-1.7.4-linux-amd64.tbz2"
  version "1.7.4"
  sha256 "eba5f35fe317efad9c97876f117eaf7a26956c435fdd2bc1a5989f0a4f70cfd3"

  bottle do
    sha256 "cf93101e6920d496966fb6ecc9e2bdfbb48e4de57259a64e31c2e82f732d2ca4" => :sierra
    sha256 "7470afc3d1235a9c1dd6ef89ba6a7e72d5e3e0e3e18b19ffe62064813834ae90" => :el_capitan
    sha256 "b860adf0b0d376f61c478d7c936e4f3078dc5203054093fe129555aa5e2fc431" => :yosemite
  end

  # put the highscores file in HOMEBREW_PREFIX/var/brogue/ instead of a
  # version-dependent location.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c999df7dff/brogue/1.7.4.patch"
    sha256 "ac5f86930a0190146ca35856266e8e8af06ac925bc8ae4c73c202352f258669c"
  end

  def install
    (var/"brogue").mkpath

    doc.install "Readme.rtf" => "README.rtf"
    doc.install "agpl.txt" => "COPYING"

    system "make", "clean", "curses"

    # The files are installed in libexec
    # and the provided `brogue` shell script,
    # which is just a convenient way to launch the game,
    # is placed in the `bin` directory.
    inreplace "brogue", %r{`dirname \$0`/bin$}, libexec
    bin.install "brogue"
    libexec.install "bin/brogue", "bin/keymap"
  end

  def caveats; <<-EOS.undent
    If you are upgrading from 1.7.2, you need to copy your highscores file:
        cp #{HOMEBREW_PREFIX}/Cellar/#{name}/1.7.2/BrogueHighScores.txt #{var}/brogue/
    EOS
  end

  test do
    system "#{bin}/brogue", "--version"
  end
end
