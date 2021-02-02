class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.104.0",
      revision: "09bd305621027b86dadbafa3ddf06c881d6dacbf"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, big_sur: "01176f94a74d94c33d1c4b46e337239c1771923b1997b92d9e48b5f3f828e8c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cdc96323915a1a9517058316ae98554d22106c4f8ba7264d4db870b9579e9b1b"
    sha256 cellar: :any, catalina: "fc0be0dc6d16e47168830aa3f19df62a8d32b7545ef49c308f50c5254e1129c8"
    sha256 cellar: :any, mojave: "506742a4de59cf9f68504934744ff8cc4fd1e391ebebf9aa735b532e67194982"
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
