class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.13.0.tar.gz"
  sha256 "8c7ffdae0b49bd1a246f48e865610fc5b6f6bdf58057858f3ba7e9dae8368ee7"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2bbb5032bc156864cc2615133e64ffc7fd80536a78bb4572838ed27c3a9c5f7c" => :mojave
    sha256 "08b95360548270ac11188ee6057cebcd70b8944ee49f2bdf2a2c96aaca881d7d" => :high_sierra
    sha256 "e5e8d469945a8358742657ebb32e16e2b560718d9b20cf6e85dbe943cd838c3e" => :sierra
  end

  depends_on "dmd" => :build
  depends_on "pkg-config"

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
