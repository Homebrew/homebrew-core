class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.101.0",
      revision: "3843d7f9d428a3d5f8743bffdd56a0f96973b850"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "990df4ed84e82f639536afdbdd0202387a602b43929af5a81821bd334d964ddf" => :big_sur
    sha256 "2ddbe0deb4938feb339a0c6e3390ac6fb9eaee3e637d19a1cd111d7914e32e1d" => :arm64_big_sur
    sha256 "e393390652adcab0d9ae53c8f5ee718f78fdfd864f44a7957c304ae8ff97f49b" => :catalina
    sha256 "79cac1f3282dc51241691963b5209cd2fdf12bab077c5f25c18a1d5df37bf0f1" => :mojave
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
