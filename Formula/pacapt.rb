class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v3.0.2.tar.gz"
  sha256 "8eca774fbf58695cecb3160081db467e92deafba545ad6477937d1e98bc8b88e"
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
