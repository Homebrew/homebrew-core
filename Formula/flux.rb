class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.117.1",
      revision: "ec2941417680c890e968ad80938b831e17a12641"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f90aae3ff41dce7f687d0776813dfe7f0924bf77afc6ea271e4cdc7760374250"
    sha256 cellar: :any,                 big_sur:       "91b4db981df86c3d1f65b25f8c193971a65144cf12ad8915661a265eeac96a63"
    sha256 cellar: :any,                 catalina:      "e04fd2b21f76b6f8dc07fdc10b493d0f83c314a8635f793bb8f0564ac68da2e3"
    sha256 cellar: :any,                 mojave:        "5c83050c549ae7d45d7c3ea162c204480b387036152a69aac2a336dd08f8c374"
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
