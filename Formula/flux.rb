class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.112.1",
      revision: "851f36f0007cd1dc8e4630fed6f37700bc7938f6"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a2080c57fa79b25e6f9fd42d1c49c7a59ad5b36ecb1906a061e457c6bdb3e8b"
    sha256 cellar: :any,                 big_sur:       "e81166d5eaad722dc659e75df960d396bd80300928e08549dfd235bca4040494"
    sha256 cellar: :any,                 catalina:      "486a5f863ec9a38de2f2af807baf485304c46a0b4ea78300eefb2bdf50fe307c"
    sha256 cellar: :any,                 mojave:        "17fb32c9c61666dc8eec2c200873d0222cc1acf5ce8b35ecc683136c0ded4610"
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
