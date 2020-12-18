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
    sha256 "a1d5416c5fd0f6218a3e74d57d19b648b94ce1fbcfd1aa35c7f7403e784c2a5e" => :big_sur
    sha256 "45b5023993a22d6e6919275d2529856ee3a9412b080e42b37eed30c231bedda7" => :catalina
    sha256 "9be1e86260446a8612e7da8e886aca523b032bef4078ee84d598df0293420c4e" => :mojave
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
