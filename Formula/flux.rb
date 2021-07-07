class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.120.1",
      revision: "53a66ff77c95cd97b32b71ae2c2b8624c7d3f7ad"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4a7e813036fa537493a91260feb09db2671c3514d231ffcc9aa5d7e235080d5a"
    sha256 cellar: :any,                 big_sur:       "c36bcf0a75d947bc7570441083f5e90d3c4d7f1139701d35a64a733d5220ee02"
    sha256 cellar: :any,                 catalina:      "b0ed611958014f1e4c78738d926944fb5825e12cfcc0f712d2b3446bc1923fe9"
    sha256 cellar: :any,                 mojave:        "c795b02535c2b1595a46170e5394199ab91db6b638ca1881eef35d57c1b15d43"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end
