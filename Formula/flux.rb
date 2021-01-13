class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.100.1",
      revision: "4fcf3ca3f35b4033bb7b4db39831344e55c71d85"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "f3ee3265f4a2880fd6ae858f34c917a32a48e84e47a34b2592ae6cca76df1e62" => :big_sur
    sha256 "97adbaf789020ebbfaed062a9c016a4d8f30a50011a307ce6833a45f8d2ebcf7" => :catalina
    sha256 "3e8ec13e70de9d1976274c1dd0ea720a63bc0e4c6b81a7a6b247f614c62f1f61" => :mojave
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
