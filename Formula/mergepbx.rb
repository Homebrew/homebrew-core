class Mergepbx < Formula
  desc "Merge XCode project files in git"
  homepage "https://github.com/simonwagner/mergepbx"
  url "https://github.com/simonwagner/mergepbx/archive/v0.10.tar.gz"
  sha256 "1727ea75ffbd95426fe5d1d825bfcfb82dbea3dbc03e96f6d7d7ab2699c67572"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e8740ccec42d1737b1e70fb70f0dd13939d24c7cb81e6b2c400309e38763fa5c"
    sha256 cellar: :any_skip_relocation, big_sur:       "6968dbb45ad1d9aac2df4b002e0a487e7d460c30e82f1a77f2dfeba6b3f652a5"
    sha256 cellar: :any_skip_relocation, catalina:      "afb3b3ce84c58a241b7c96e81068851273d1fdd31403737a13ae1e75ba57240f"
    sha256 cellar: :any_skip_relocation, mojave:        "8188a967c09aadd08807dc11cb6695ebc6def26026532d426fd3bf1880fdc591"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2e295ff99574735aa7d1bb5244f1207a1f6f2054c4ec9da322e9d0981bdd5dd3"
    sha256 cellar: :any_skip_relocation, sierra:        "35a545aa5eb9b4d761134818b792f50e007d7bb6235fbbf54e7733a8e35d742e"
    sha256 cellar: :any_skip_relocation, el_capitan:    "9330e987d0c93a73b9edfbc77f265fa225b058d36b9210c797fe02494d1a656f"
    sha256 cellar: :any_skip_relocation, yosemite:      "77c1ec431ae1a7cd6fb4b04376e14e8aa1f7399cf840e006caf69c0f88839a7e"
    sha256 cellar: :any_skip_relocation, all:           "8ecddaec0eaeb4d63ccc9935e66c8f0b5bf7a5a07fbb313909270e47088bf590"
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
