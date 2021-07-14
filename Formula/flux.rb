class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.122.0",
      revision: "b0628cf8d0120ee1b7c78878f3c166b80c32df11"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22a31f3540f5bf1a37573d1483e54cc9d143973685561b50ed3058cf400ee19a"
    sha256 cellar: :any,                 big_sur:       "c5b1aedbf275fc6808f3f2fd8fe1858e7a91795cdc7d180088819c2770e49da9"
    sha256 cellar: :any,                 catalina:      "03a3dd6d6cccf4448d8b4572bebd8ee37612dbb0aab72c1ca37184b296166c9b"
    sha256 cellar: :any,                 mojave:        "f41705dcc6cc186e714259deadd8d55bebc3e04c05fb652f097817a4463dbe56"
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
