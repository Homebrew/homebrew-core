class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.116.0",
      revision: "c945afc8d8ab260216776e07f3b15f17d406c3a6"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b6c6cb0f75d7f08a0f276eeefd21b64f503abdb3e1ec20cabbb163bb9087452"
    sha256 cellar: :any,                 big_sur:       "94e9db3fc9a8ab1edad9ef010eaebadf1a0b5ec5b7cee48d59a8b6f977b22251"
    sha256 cellar: :any,                 catalina:      "5c6ab736c144359eadb3b249767b7b4a04475b71c9ce10869dd6ef108f035c24"
    sha256 cellar: :any,                 mojave:        "40d383f6b7e6fa77b735ea62bd399a0024fa773f47a2aaa6d2acc2199b37adcf"
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
