class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.121.0",
      revision: "a00559a570afeab0dfe3915121a3b17be4632f82"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1cf4e5824b5986e4cda24dd40778794cac198105ad91455c74a5e626f97dfdf4"
    sha256 cellar: :any,                 big_sur:       "564eb1eb4444d5fe3ce52086104600eea42b9e7446ce0dc8a3007f66bb713c52"
    sha256 cellar: :any,                 catalina:      "024f042783e160a27e6f411140cecdb2f5676576d041a7814e1d017bbf716f19"
    sha256 cellar: :any,                 mojave:        "1e01be0b9e4f2201c712f405d0eb80789b3aa18cc183a50d255f2b2016c447ca"
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
