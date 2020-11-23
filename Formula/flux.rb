class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.96.0",
      revision: "9c3cf772426aef125c979c81d93e0dda37ab95b8"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url "https://github.com/influxdata/flux/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "1fe90ac54ecbc345199084e5668849ba17ab8356252dcca685b1c16d94edb31e" => :big_sur
    sha256 "689eed4de5fedb95de3bb039d50278c727df292d43238cc455bd912a308451f1" => :catalina
    sha256 "0cccaeb72e45422749d77e630a6e123c45c6b71595e9213d5e36836f9630e9f3" => :mojave
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    lib.install "libflux/target/x86_64-apple-darwin/release/libflux.dylib"
    lib.install "libflux/target/x86_64-apple-darwin/release/libflux.a"
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end
