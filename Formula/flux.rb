class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.112.0",
      revision: "b9b7f50e098a28318b6dee5032a2da18d51eab9d"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a218f73bccb9743ef13aeb219e02e8f06ebf273d1358acff3913269eb8ce29f1"
    sha256 cellar: :any,                 big_sur:       "f24e080f7bf8b327a43a505eb2ba2b7e0dfb08b8b3bb0aa58047819a55d54886"
    sha256 cellar: :any,                 catalina:      "0284b0e019bfd69ef77ab1f3e07b5129256e8cbff5d8feb5a4cad1275e9c8774"
    sha256 cellar: :any,                 mojave:        "7587f7230b6606ea13c79fe81249f6f42ba0bcf25aee64b413862091de59147e"
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
