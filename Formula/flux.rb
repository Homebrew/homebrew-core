class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.104.0",
      revision: "09bd305621027b86dadbafa3ddf06c881d6dacbf"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "67d12f917aa7cbdfc842e31dd45e2103a13b7c42bb523dcc955bead4abf43d70"
    sha256 cellar: :any,                 big_sur:       "11c834d452e4ad81e8f43a76c785ef641440969916e425c60dab4edb383741db"
    sha256 cellar: :any,                 catalina:      "8ae9c9eb21a4a6ef5ac62afff99b6acd60b827be79ff5e70c0d469ce0af2a944"
    sha256 cellar: :any,                 mojave:        "43858d6b6f0d2f47eb95c1d0e47b3b8ce9dff3f316246f1636954b12f77cac0d"
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
