class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.106.0",
      revision: "e764a70f36b8531a6879e081f68eb4458e0f05bf"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30f34df5a0204e360b593f1102992b22d6b41e2f83be4ae4e5136194e1b18dd2"
    sha256 cellar: :any,                 big_sur:       "3cd598ed1e8a4aa1da2125bb128671a51b661a82f0566750d563b2a8267184fc"
    sha256 cellar: :any,                 catalina:      "801b50a4d08129fd87ae51f90da6a3413faeca6c04b2acbcbe5ee822a9986da6"
    sha256 cellar: :any,                 mojave:        "225f07d17dc95e3327cc9d8afe1b877b8c9fd0cd04320f0ea08464c12af88a93"
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
