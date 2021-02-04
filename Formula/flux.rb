class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.105.0",
      revision: "0f51f73f7773e149dfb9ed8132af49750fbb3298"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "02d660830c1cb32f100f7eb32231ca2e6f2d94a4a506a2e2da10af8abedc57b2"
    sha256 cellar: :any,                 big_sur:       "791262d2de5b0a1aff11f81aa8ac4efa853ede77460aa7cd9f45c310f4ec14c8"
    sha256 cellar: :any,                 catalina:      "b1b4742477826eaf7e034d1478b6855008b10557ec690259ba87e97e1c559b48"
    sha256 cellar: :any,                 mojave:        "90cb211a2adeaeae9497ab6d9dc409d1438e49b902560a45eae507f413cc87a8"
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
