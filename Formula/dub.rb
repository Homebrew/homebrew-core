class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/dlang/dub/archive/v1.1.2.tar.gz"
  sha256 "2945c8ab52a421da3ae4c64cc655e3322bd01a9a15ef1ea0208ec999d0e36b91"

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "9d96e4cba1202ca9273b5f93dd2864357f0635b239f1e39fe9eff79c2bc12cb6" => :sierra
    sha256 "9aae20df2e96270f61f2694676be3f1710fd935b5a578cbecbf0e041d90eec35" => :el_capitan
    sha256 "d067fcbfec11e40e32d07bd91ace0c1d64c787b39ba9f21dfd6b362307abcb72" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.2.0-beta.2.tar.gz"
    sha256 "d319620d17fcc9d8c43cc2f958ff3147b0d36aac8f5c62200af5e56960404cff"
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    system "#{bin}/dub; true"
  end
end
