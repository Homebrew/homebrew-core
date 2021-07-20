class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.123.0",
      revision: "a768568a4cbeb299433ee31a059e599d290fcfbf"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "80c94f6f6fed0b234fd4cfa84ba5b8bf9ba3fd5b2e6df5ec53a359982d8933a8"
    sha256 cellar: :any,                 big_sur:       "b2aaa210137bd075a90a3710456b3b65874b43f1b0915444f3c9f688dd12b4ac"
    sha256 cellar: :any,                 catalina:      "0490638c575afd7d35a173115be03dc5b30272acacdcbbe12f983329118a99f7"
    sha256 cellar: :any,                 mojave:        "d694cdadada63594372285da1b9f511445f3a366184d3827f376afab447ae098"
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
