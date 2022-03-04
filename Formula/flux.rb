class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.157.1",
      revision: "59e6485e13e6d3bd27262abd27074c06ee80bf3e"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "50860bc9996e7f911752ad6b02ea11b6a49e77541ce3cb7b1bb542b24f5460d1"
    sha256 cellar: :any,                 arm64_big_sur:  "2ae4858ad2469c8599da7ef9d869ed0d79f54dcfa95044409dc700fabfa8bdec"
    sha256 cellar: :any,                 monterey:       "563d0f8a27db2ab86cfeda94873bf36b7f34f5b447f22ac82c69181fabf2ce0f"
    sha256 cellar: :any,                 big_sur:        "9ed541b2888bd0406253baab3743c641c178bcc0711669800f0c5004c1eda78d"
    sha256 cellar: :any,                 catalina:       "9409fdc9294cfcba85c73b1531250456df5125e5db3f5fe888e1d7e22a784f18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31b056c9cde18180685951d8375c6de1ca587b89d3cf5c961ff17f4e91acd0c4"
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
