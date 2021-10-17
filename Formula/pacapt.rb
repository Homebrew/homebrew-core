class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v3.0.5.tar.gz"
  sha256 "c68cd6b8367934f58ab06a131dfbc91ab12ada2baee92ad4246b56729e9cad8d"
  license "Fair"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "376eb885dea7254cd900e0f2ca415283b0f42c762c9bc4c332bbfb6f02084cbb"
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
