class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/dlang/dub/archive/v0.9.25.tar.gz"
  sha256 "e0c759d4b170cb0a57c2a4b35b700ef9e2eb4714aa27968be9403fae7bb14c86"
  head "https://github.com/dlang/dub.git", :shallow => false

  bottle do
    sha256 "bf14b900869d28bc8140731ee81d04d9ee5b456603dea51353863bd76358f49d" => :el_capitan
    sha256 "5cdd5f8c6729f3acf955afbd8d383daf196318bf1d2278085a28c28af00d33ce" => :yosemite
    sha256 "33db147c048a39cad51569940ff489e015a08f3d17d0c299efcce89c064a8513" => :mavericks
  end

  # No devel tag currently available in the repository.
  #
  # devel do
  #   url "https://github.com/rejectedsoftware/dub/archive/v0.9.25-rc.1.tar.gz"
  #   sha256 "577e127e5e361d1ed7fe6ef40100e91e361dd7063f304afeab7ae5a6274005de"
  #   version "0.9.25-rc.1"
  # end

  depends_on "pkg-config" => :build
  depends_on "dmd" => :build

  def install
    # Create a dummy commit and tag it because build.sh uses "git describe" to compile
    # in the application version
    system "git", "init"
    system "git", "add", "dub.json"
    system "git", "commit", "-a", "-m", "'dummy commit'"
    system "git", "tag", "-a", "-m", "'dummy message'", "v#{version}"
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    system "#{bin}/dub; true"
  end
end
