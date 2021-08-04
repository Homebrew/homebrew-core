class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.124.0",
      revision: "e9849ceac023cc8015ced3ad0e8e11f7775bee6b"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "57132d1688b3bffac48b7eeb66d21d81d0611056b97fda72627fff6fbfb81979"
    sha256 cellar: :any,                 big_sur:       "25c6f3ed5b2d518ff95dd009fea06bfa45bf502b780961a3c9b4b6178c9accc6"
    sha256 cellar: :any,                 catalina:      "fa8efeb39b1aaa9eaf76a12fd0c34da76713ce07c13dc2de11911fbf0a8e43cc"
    sha256 cellar: :any,                 mojave:        "344576fcb909c4ca411341560253b678783a45c16b6903791fbc461d77ffa554"
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
