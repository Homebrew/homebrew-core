class FuzzyFind < Formula
  desc "Fuzzy filename finder matching across directories as well as files"
  homepage "https://github.com/silentbicycle/ff"
  url "https://github.com/silentbicycle/ff/archive/v0.6-flag-features.tar.gz"
  version "0.6.0"
  sha256 "104300ba16af18d60ef3c11d70d2ec2a95ddf38632d08e4f99644050db6035cb"
  license "MIT"
  head "https://github.com/silentbicycle/ff.git", branch: "master"

  # This regex intentionally allows anything to come after the numeric version
  # (instead of using $ at the end like we normally do). These tags have a
  # format like `0.6-flag-features` or `v0.5-first-form`, where the trailing
  # text seems to be a release name. This regex may become a problem in the
  # future if we encounter releases like `1.2-alpha1` `1.2-rc1`, etc.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81ff5be190dd0e8d539f7a0e3a366737db3fb72faae8c310f99ee462e4333f5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40e202174aca2e775cea7f47b1936ca0cc209e2e9a96a9f9e2b9b8bd6ac7d3cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35ce926faa74b7f843cd9f5facb104ade3474989156d4bdbdb61a3abaef89cac"
    sha256 cellar: :any_skip_relocation, ventura:        "30e4f0f37ffa934c2bf2c62cb1f15a3f4cd0ec3a0ab54b8524e0f33cccd2aa0e"
    sha256 cellar: :any_skip_relocation, monterey:       "71dfdb9fbe7c51760e5095165eb35844a15435e685154a03ea9c5ce314916d00"
    sha256 cellar: :any_skip_relocation, big_sur:        "937f20d35befb11463217b680f1924321cfbec7a62273c48fbb7cad4bd898140"
    sha256 cellar: :any_skip_relocation, catalina:       "4e58e0ac23df5dbd26787238c0160716db8eb673b4a62625a9edcb4ceaf38eac"
    sha256 cellar: :any_skip_relocation, mojave:         "1a7bddb6228630cd27bd08863e41eaa01211dae1e5d409dd4ea9777c1599057d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b3f47d3bfd49f76960e5979fd4ef898c848e73f7f8da758b71c7eefe3f585fe0"
    sha256 cellar: :any_skip_relocation, sierra:         "feefa3913b9b1df2d8b283fdd55abd1de9ee924633d8e157142cce4980572ffb"
    sha256 cellar: :any_skip_relocation, el_capitan:     "7db1b187adfcb7ce37842891ffca5eec3ca25bed5441944cbeb1e08bc6d52a66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "593e66d2856edda48ca5deeede9473fcd2d0443436238659239a3ddbda483514"
  end

  def install
    system "make"
    bin.install "ff"
    man1.install "ff.1"
    elisp.install "fuzzy-find.el"
  end

  test do
    system bin/"ff", "-t"
  end
end
