class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.151.0",
      revision: "4db5fa9f19517cbcd6fe5d651c80067f4bd681e8"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b3b28cd65343a672717e066795e1d5d69a34ede6ba3971db11ae196eafcb0d64"
    sha256 cellar: :any,                 arm64_big_sur:  "8b029a19fcae9a35b2e02ac4c9571b455be1c0c010a9db97cd162d9f028bde33"
    sha256 cellar: :any,                 monterey:       "65754f738912024ba9925dd7cf021c82ede55a3bbefd4ce83aadf777e7aed553"
    sha256 cellar: :any,                 big_sur:        "a8cc64020c2f6b4e83e59da0dc81129aeae1f3f21497068c3c3b6c6774a35bbb"
    sha256 cellar: :any,                 catalina:       "98ee07177c411b49573d46480475e17d3e022acf3f300898c4742763d0e254a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b70e070727934ba60924884a5fbf3c7f97f666bd291ac827dc0b0db7da7d890"
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
