class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.2.0.tar.gz"
  sha256 "836caddb30ad5972a453269b027f614d51b5fd2f751a0fe63cfeb0be7388a8e9"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    sha256 "9d96e4cba1202ca9273b5f93dd2864357f0635b239f1e39fe9eff79c2bc12cb6" => :sierra
    sha256 "9aae20df2e96270f61f2694676be3f1710fd935b5a578cbecbf0e041d90eec35" => :el_capitan
    sha256 "d067fcbfec11e40e32d07bd91ace0c1d64c787b39ba9f21dfd6b362307abcb72" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.2.1-beta.1.tar.gz"
    sha256 "8d0a8fd59afaf23194b99dd4e5b3ffd65c56f9d9da74d762d01fba9af6d79b07"
    version "1.2.1-beta.1"
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version")
  end
end
