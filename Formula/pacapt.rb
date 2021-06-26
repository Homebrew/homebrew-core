class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v3.0.0.tar.gz"
  sha256 "718b54bbf7fd71d018df5fb094e853c61a32e7cf9b94a402b70deb09ac84ca5f"
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
