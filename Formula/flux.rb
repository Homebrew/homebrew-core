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
    sha256 "db5a7adde712f1874d90a9b9da3b0a9ec63f2b0925ab4b84f8438528098b3714" => :big_sur
    sha256 "823c3b21063fe38784315263aea12bd9185ffa3b1bc8f8120a4ae1a6f814be10" => :arm64_big_sur
    sha256 "2f24b7e81975b7b3330ab5344ea5a3f558bc1cb31ff674b598a92c60c73f0a0a" => :catalina
    sha256 "72b7ab5f16a3a880645afb97f0a30e7353442182bf3dfc3a36b5b19b66fb104b" => :mojave
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
