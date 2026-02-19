class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "d1081b639466de7650ed66c7bb5a522482c60c24b03c292c46b86a3983e66234"
  license "Fair"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "6691ef309d2ebf4b001358e04a24bf93569f5dfc42c31811cadffd6c3e605444"
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system bin/"pacapt", "-Ss", "wget"
  end
end
