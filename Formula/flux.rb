class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.109.1",
      revision: "ec2765ef083dedb127b7bfb8aa4ac7f956e404d5"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83f1401293f5144ad87b29eb731fb4cc6bfb446b53d91cdd46995addfc4a0368"
    sha256 cellar: :any,                 big_sur:       "ce81eb76896e4e1a171223c6eb8cb7610850ddf509ebb0e7e930fac537132933"
    sha256 cellar: :any,                 catalina:      "a595601083e970c5c0231b5a0055c644bba00146ec2dec5f545df1329a78ba8a"
    sha256 cellar: :any,                 mojave:        "6daa14366260eaa124fe454f3000976f36cb729b682e9ce70dc6c5804a08030f"
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
