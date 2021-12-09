class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.144.0",
      revision: "eb10cfb089b18e702dd81e3f64a660425c7c6b82"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09b8199b63ad7734ebad5be0e49428c90eb64e6e710ec954a5b38c3e8b8bc6ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d60048b5324e48b45e580839f68b8bc14ea1663e56eb76117272ff759b319782"
    sha256 cellar: :any,                 monterey:       "df072197f8670b20a24d70d874219c1fbb22734218354afb2249e9331017706f"
    sha256 cellar: :any,                 big_sur:        "443c4c9671342ac7486a754ec6733804070ba3aa113c3d859703e3321724be30"
    sha256 cellar: :any,                 catalina:       "bded1c108f6ecbea1f1c386812006213a321a887ea74b79c6af547cc5d775089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9aba36c6f0ef981a28c8b373dd13fae40b7449fda48d57ef450687fea7eb6fd"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/v0.2.9.tar.gz"
    sha256 "25843e58a3e6994bdafffbc0ef0844978a3d1f999915d6770cb73505fcf87e44"
  end

  def install
    # Set up the influxdata pkg-config wrapper to enable just-in-time compilation & linking
    # of the Rust components in the server.
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args(output: buildpath/"bootstrap/pkg-config")
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    system "make", "build"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flux"
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    assert_equal "8\n", shell_output(bin/"flux execute \"5.0 + 3.0\"")
  end
end
