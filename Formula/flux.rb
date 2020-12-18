class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.99.0",
      revision: "2c56fe7a54c0c9a61b24854eb6ad9e143886c56e"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "367caf1fccf26f51eacae8f3b196b4e1379291eb8319154e7c2975d0c4d7864a" => :big_sur
    sha256 "9778ae0370bf3af6c75d122fc34cc256c443b375924036dd9010b4300cfdce84" => :catalina
    sha256 "2020fabfca64466ddc2d60afd7b41c67a33e7c85dddc3a6ff768943ee6cc6568" => :mojave
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
