class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.105.1",
      revision: "cfe404620069347e7e4e11424bf6b954034b2823"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0b48774e182ac87bc06e283a0c1cd25deb860d6f0f308f289de3972d4a331dbd"
    sha256 cellar: :any,                 big_sur:       "97b5fe7bfb799e85dd27b2452e23cd603ef69cc97de8f3ed2d2249973a3613da"
    sha256 cellar: :any,                 catalina:      "82ee4236657027a9738ade4faf64be38de13aec9ad8e3ee6b39d9642353cb3d0"
    sha256 cellar: :any,                 mojave:        "3d6520a2c3d1b0fb9baf1bbcdbc1591154970fa8557aaa2c9cb5846c3c4bbc67"
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
