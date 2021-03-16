class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.108.1",
      revision: "0546f24e73a00d134940d1a002c5f271e2e05e26"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f83a206deb0a1efb43cb8c4173d4d0d6aab011586ae84e50f946d201cbfb4271"
    sha256 cellar: :any,                 big_sur:       "dd546db9f9f426a965af3c7dec650b4ddd9cfcb55924e6dc86a749ce204bb2ca"
    sha256 cellar: :any,                 catalina:      "b95c6a0e9bee1dc30586a40fdee3e8069dd9ed0ab4c168e6d56678c102d4f3fa"
    sha256 cellar: :any,                 mojave:        "aee2ed1336b8105009189e9e15b28aed6f6e79a593d8c7d00899a15709d9f7d2"
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
