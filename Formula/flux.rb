class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.118.1",
      revision: "0cbc4c4cb9b897b1e8d9b1175cbe9328c93e33e7"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "225ed2068502bb3e45acd3082f1503da26ab53c3c5a9e23bb7ca333812d284cb"
    sha256 cellar: :any,                 big_sur:       "e4d9000c049a7c87fde3d6f993e053d30c9e220859290790be93cd9799ab6973"
    sha256 cellar: :any,                 catalina:      "4f0e58725b3b97a7b1b2ae027515d6e65cdce0a2b227f02ab7b1280b6cd8849f"
    sha256 cellar: :any,                 mojave:        "abfad44555916a7ee18fdb485a370484b29c44c1b97bd82c2d884bc622a6678c"
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
