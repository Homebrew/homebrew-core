class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/dlang/dub.git", :tag => "v0.9.25", :revision => "777e0033e9ca502c134a6cca6b5a06d0e3f78617"
  head "https://github.com/dlang/dub.git", :shallow => false

  bottle do
    sha256 "bf14b900869d28bc8140731ee81d04d9ee5b456603dea51353863bd76358f49d" => :el_capitan
    sha256 "5cdd5f8c6729f3acf955afbd8d383daf196318bf1d2278085a28c28af00d33ce" => :yosemite
    sha256 "33db147c048a39cad51569940ff489e015a08f3d17d0c299efcce89c064a8513" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "dmd" => :build

  def install
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    system "#{bin}/dub; true"
  end
end
