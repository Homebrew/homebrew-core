class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.119.1",
      revision: "8be007977ef420f55093e5f869fdaa706d534723"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b1c4304d3d7f1289322e34108cf238637c47592bdac182814388e870380d7349"
    sha256 cellar: :any,                 big_sur:       "fad056b017f58cbbbdcf323a61e32f1f312731396b985cffc5c7256fbd92aacf"
    sha256 cellar: :any,                 catalina:      "1dbc1f5b1e96c1338b6f97f15d4054c7d8faa6def5caafe873b4406a2f64ee21"
    sha256 cellar: :any,                 mojave:        "05f74708e8871f23027a43e5c50cc5e9683517da67a8bcf631fccedb28221ec1"
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
