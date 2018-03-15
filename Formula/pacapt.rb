class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v2.3.14.tar.gz"
  sha256 "73683fcd9414fc745cc26b734dad6b5b4d37227b4e2336b787f985d3b1323526"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f69f27536059701100c0130ab2c06381f02629f2610af0b576cc8cae196abb4" => :high_sierra
    sha256 "000a282250eba0c958445cb4a1137d938c17b338e25ea9e4771844155627728a" => :sierra
    sha256 "000a282250eba0c958445cb4a1137d938c17b338e25ea9e4771844155627728a" => :el_capitan
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
