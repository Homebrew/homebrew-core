class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.95.0",
      revision: "2e0f9dd8dbf9417d7f83010a3912ded9a61e7237"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url "https://github.com/influxdata/flux/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "25e973a0a257ab97c295b371715d97fc0b0789a76ce067dd963a807af6da1e6e" => :big_sur
    sha256 "b1b981c9c6d0189d3c4fc93795077dfb04ee8349b33b19929f76c79993f373c0" => :catalina
    sha256 "bad9cd01d1a588e2a8de1ddbdb85b152d98645232781f3bfcf718c6b2282f48d" => :mojave
    sha256 "94d271d3a87ae8086197e5945488be7b8684a3fefc57a3ead34e26253b05fede" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    lib.install "libflux/target/x86_64-apple-darwin/release/libflux.dylib"
    lib.install "libflux/target/x86_64-apple-darwin/release/libflux.a"
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end
