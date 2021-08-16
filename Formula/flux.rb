class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.125.0",
      revision: "7043c60750bb4fc44eeea9b101d3fb3cd737e047"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "871883bdacfbf8e3983271b639128b0780eb0ec8ecf1414429eddf1d14ef5d01"
    sha256 cellar: :any,                 big_sur:       "4b07501f101eb329c356147562750e16a238b7621e8c3f296fcc2f7aac1146c1"
    sha256 cellar: :any,                 catalina:      "0f29432b99ea41aae92c9167bc05b91fe4356ebc5b3c9812179c54f18456074b"
    sha256 cellar: :any,                 mojave:        "3acb0cc7e252605837fafe6c0c9b76b5e661cd53dcd132224931448e347d3cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "066791b4fce048ba230d1040fe4fb4ebcb83c75f959d94e14edad04a1ecaab47"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

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
