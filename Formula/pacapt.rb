class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v2.4.0.tar.gz"
  sha256 "9f43d727ae25750661c155126479f00d9742ef5623a05b98da11561cd402534e"

  bottle do
    cellar :any_skip_relocation
    sha256 "15a4adaeae087d3f7d21074293bd401a4a63e56ebdd307cce3054039bd4ed9d1" => :mojave
    sha256 "041c799bd75724e4a25ab4594a64dbe4fdd3ee152e68b552cf9564d9051972d5" => :high_sierra
    sha256 "041c799bd75724e4a25ab4594a64dbe4fdd3ee152e68b552cf9564d9051972d5" => :sierra
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
