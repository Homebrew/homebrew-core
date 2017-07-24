class Convmv < Formula
  desc "Filename encoding conversion tool"
  homepage "https://www.j3e.de/linux/convmv/"
  url "https://www.j3e.de/linux/convmv/convmv-2.03.tar.gz"
  sha256 "f898fd850c8ef5abe48f7536e4b23ce4e11b6133974b2fc41d9197dfecc1c027"

  bottle do
    cellar :any_skip_relocation
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
