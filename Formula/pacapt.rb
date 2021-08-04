class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v3.0.4.tar.gz"
  sha256 "3f62e211fcabfe951a1369bef684996fda65faceafcd2ceeb4b738cf43622c4d"
  license "Fair"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2fbf3f83c03f7d01205a46e1ffeeec36608bc0a45da4ce1a1a8902a1cfaa704d"
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
