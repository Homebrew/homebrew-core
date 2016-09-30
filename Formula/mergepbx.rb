class Mergepbx < Formula
  desc "Merge XCode project files in git"
  homepage "https://github.com/simonwagner/mergepbx"
  url "https://github.com/simonwagner/mergepbx/archive/v0.10.tar.gz"
  sha256 "1727ea75ffbd95426fe5d1d825bfcfb82dbea3dbc03e96f6d7d7ab2699c67572"

  bottle do
    cellar :any_skip_relocation
    sha256 "35a545aa5eb9b4d761134818b792f50e007d7bb6235fbbf54e7733a8e35d742e" => :sierra
    sha256 "9330e987d0c93a73b9edfbc77f265fa225b058d36b9210c797fe02494d1a656f" => :el_capitan
    sha256 "77c1ec431ae1a7cd6fb4b04376e14e8aa1f7399cf840e006caf69c0f88839a7e" => :yosemite
    sha256 "690559c9a95577702180b53493822f2c6887d2896f27c26cdfe9f2cad506809e" => :mavericks
  end

  resource "dummy_base" do
    url "https://raw.githubusercontent.com/simonwagner/mergepbx/a9bd9d8f4a732eff989ea03fbc0d78f6f6fb594f/test/fixtures/merge/dummy/dummy1/project.pbxproj.base"
    sha256 "d2cf3fdec1b37489e9bc219c82a7ee945c3dfc4672c8b4e89bc08ae0087d6477"
  end

  resource "dummy_mine" do
    url "https://raw.githubusercontent.com/simonwagner/mergepbx/a9bd9d8f4a732eff989ea03fbc0d78f6f6fb594f/test/fixtures/merge/dummy/dummy1/project.pbxproj.mine"
    sha256 "4c7147fbe518da6fa580879ff15a937be17ce1c0bc8edaaa15e1ef99a7b84282"
  end

  resource "dummy_theirs" do
    url "https://raw.githubusercontent.com/simonwagner/mergepbx/a9bd9d8f4a732eff989ea03fbc0d78f6f6fb594f/test/fixtures/merge/dummy/dummy1/project.pbxproj.theirs"
    sha256 "22bc5df1c602261e71f156768a851d3de9fa2561588822a17b4d3c9ee7b77901"
  end

  def install
    system "./build.py"
    bin.install "mergepbx"
  end

  test do
    system bin/"mergepbx", "-h"
    resources.each { |r| r.stage testpath }
    system bin/"mergepbx", *Dir["project.pbxproj.{base,mine,theirs}"]
  end
end
