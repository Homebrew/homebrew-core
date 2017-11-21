class Convmv < Formula
  desc "Filename encoding conversion tool"
  homepage "https://www.j3e.de/linux/convmv/"
  url "https://www.j3e.de/linux/convmv/convmv-2.04.tar.gz"
  sha256 "de1b794cbc73cb9816869b1e3ae358ad9455ced5a4504b1e5cd0084a63b0bd1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "74a04a32a39e2cf2da9225e59002526b0e7b5a3d0b42d4026e7da6fac0578a9b" => :high_sierra
    sha256 "ce361994aa56f755bc2d8f03da5ce8f1c57f5e7515cb4062f180871ef6419180" => :sierra
    sha256 "283f9f19b9bd5d494f4c05ef26d52420f9569570928164c3be75320ce71885a2" => :el_capitan
    sha256 "283f9f19b9bd5d494f4c05ef26d52420f9569570928164c3be75320ce71885a2" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/convmv", "--list"
  end
end
