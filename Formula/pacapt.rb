class Pacapt < Formula
  desc "Package manager in the style or Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v2.3.11.tar.gz"
  sha256 "e947cfd65f5d5acab2aa7f1a2fe0930c815bc7766230da40911bac7bb782ff0c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d2c7835da1f6a8757509d6cf39b4628b4f718874d51534b40c7610cf3170aaf" => :el_capitan
    sha256 "cf581fde8d82808464244f7448f270c0b06a73c43248f834fc0e203df41914f6" => :yosemite
    sha256 "a0f15f58f40a9270f449daf77cef89a58e2d9b04acbe3da94e467ee77e5311ec" => :mavericks
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
