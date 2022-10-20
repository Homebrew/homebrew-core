class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v3.0.7.tar.gz"
  sha256 "d1081b639466de7650ed66c7bb5a522482c60c24b03c292c46b86a3983e66234"
  license "Fair"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb8be933786f8348cc9852b23098c5b3186c2111d0aa7f4a5fd637bec3dae051"
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
