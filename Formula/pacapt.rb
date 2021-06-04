class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v2.4.4.tar.gz"
  sha256 "4063c136f5f89f7f49e09c1c38d0e018aca1f48d9d407458600a75395744afc5"
  license "Fair"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b56c302d42d411afc589d987acfc7d512832c4b48203b2c95bca9461578ec54d"
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
