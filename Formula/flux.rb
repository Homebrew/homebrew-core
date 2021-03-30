class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.111.0",
      revision: "e62f0d39002b5a149cfb8361060a1d2bdc4ebe3d"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "35d629f326024111c86819909e25371859b5b5e429213b1cd640591b0965d306"
    sha256 cellar: :any,                 big_sur:       "ee7bf9662edc1f8012dc21209c0c150cdc4981fef8e47d580fc28614718eae1c"
    sha256 cellar: :any,                 catalina:      "02d1c60430afdc17bca2c1f00aee0d8a084e09728532b5f38447c221e554a4dd"
    sha256 cellar: :any,                 mojave:        "9d35167eba4454178e9eb37e43bff4b668749f9740cfc167421da659c2747012"
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
