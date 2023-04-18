class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.36.tar.bz2"
  sha256 "0b7614e47f6711ce58cfbee7188d56d17a92c104004f51ab61798b318e897d8f"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?dMagnetic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "04a28c563b190acca6d3d0167e1476438717e558d243123fd821f4960c3f5ad2"
    sha256 arm64_monterey: "4c7bbc22b20743ad1b6c45077c857ece0b446231686fbe664b21897434eb874d"
    sha256 arm64_big_sur:  "c1a5fb93957fada941cc457a37406a43918e7c7eb1af4579c241edc43caa0868"
    sha256 ventura:        "cb334115639d028f1c25661276aab6ef2c84db2e0bddfe7875bee3c5a07cc94c"
    sha256 monterey:       "13a91829e4bca711a5e6dfbdb02292777f4ce3c836748a291df1aa601a055bc2"
    sha256 big_sur:        "9e135dc4b24c390eb50527e84f7d915ba5b060429ec3c2e273e2fd6ebfe37693"
    sha256 x86_64_linux:   "a89c211a9cd74bffa552a5d34fb90db3a3abbf20aba22e0d6d56dc0ba49ae387"
  end

  def install
    # Look for configuration and other data within the Homebrew prefix rather than the default paths
    inreplace "src/frontends/default/pathnames.h" do |s|
      s.gsub! "/etc/", "#{etc}/"
      s.gsub! "/usr/local/", "#{HOMEBREW_PREFIX}/"
    end

    system "make", "PREFIX=#{prefix}", "install"
    (share/"games/dMagnetic").install "testcode/minitest.mag", "testcode/minitest.gfx"
  end

  test do
    args = %W[
      -vmode none
      -vcols 300
      -vrows 300
      -vecho -sres 1024x768
      -mag #{share}/games/dMagnetic/minitest.mag
      -gfx #{share}/games/dMagnetic/minitest.gfx
    ]
    command_output = pipe_output("#{bin}/dMagnetic #{args.join(" ")}", "Hello\n")
    assert_match(/^Virtual machine is running\..*\n> HELLO$/, command_output)
  end
end
