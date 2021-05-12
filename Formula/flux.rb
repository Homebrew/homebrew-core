class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.115.0",
      revision: "6c92e39ef008c84e41d8c538000f63929bc5465f"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd91c49404174c1ba144c7a0e38d7adcfc4544bfa32e9c3a3db2146f2d6dc2fd"
    sha256 cellar: :any,                 big_sur:       "da4f31757fb58d9187f063c72c11146521af858459f9f0c821c6bc366ed262f8"
    sha256 cellar: :any,                 catalina:      "68b8c13a44ca0d0ec04e3a2dd5bcb4988226335e693a62ccda0d17dcda46577b"
    sha256 cellar: :any,                 mojave:        "e7065e47c8f418e010fad574a7458752934d36cb68683254eb3d4cf2b77e8ab4"
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
