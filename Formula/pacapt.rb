class Pacapt < Formula
  desc "Package manager in the style of Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v2.3.15.tar.gz"
  sha256 "766f10320082c542fba2a5db1e0dab46e51dc45be07ade53c99a1ce3b1591245"

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
