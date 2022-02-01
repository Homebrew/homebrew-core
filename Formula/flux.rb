class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.152.0",
      revision: "7a01fff54085c97bf3099f929846edff63f05ed2"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "90ce162063474985d03c93cb506a6c55be6427739f252267fa74f1d260af5ab2"
    sha256 cellar: :any,                 arm64_big_sur:  "8b2ec09bcaa3b5bcec2152e4d6ccba780de42baf1360736c288a41938f1bafbe"
    sha256 cellar: :any,                 monterey:       "b833c38fa1e20a22b5373a4107a1b23047ca9cf28d89e7edc852bffcf8c8391b"
    sha256 cellar: :any,                 big_sur:        "4a4a821e3bf3a18e83e1b106d335c54902ee893c558c3b793c83800f1586ee08"
    sha256 cellar: :any,                 catalina:       "acfeecfc3cb61800edece0ced733a8c8b7fce037efbf9a8b320badef31b2c412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84995198db9d42dbafacb6715fb08961b25c628e819fd64ab8cbdfcf63183a2f"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/v0.2.11.tar.gz"
    sha256 "52b22c151163dfb051fd44e7d103fc4cde6ae8ff852ffc13adeef19d21c36682"
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
