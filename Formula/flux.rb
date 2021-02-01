class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.103.0",
      revision: "e217e028da1e911fe0f909edf7ede9e24fc555ea"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "3b1a841f43aa5aadabd4cc634fefc11282b6a30f41efb42e7dad4e224dc4275b" => :big_sur
    sha256 "9adfbd97a45a5454a794ddff786d20b258dcdcd522db64b62afe62560d7d1dc4" => :arm64_big_sur
    sha256 "0d0f4c0e4c5f776a68f077cf761e8602c2c0a9d1a56422b27199f5cded3628db" => :catalina
    sha256 "6592500c177ea5d11acf91ba55110a7da2274dab16eb85108a764604de6b8ecc" => :mojave
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
