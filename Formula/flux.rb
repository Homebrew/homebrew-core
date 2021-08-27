class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.127.1",
      revision: "955bc0303789cce8938d69b55c7e1697962f1d7e"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8058fe7c0a930c5a0f93ab1a1d3c3524b1c7e06edc5a7f4f26ca1c20e2a0274d"
    sha256 cellar: :any,                 big_sur:       "d0fa7eff1f68a3bf56b4e4d933689eca65e2b6dbcf56ee0f459141ccf0a67ad3"
    sha256 cellar: :any,                 catalina:      "57280d055bf98d6f8dc7b5ad96582dbe550e6c68eb8f672345db1910f6b87036"
    sha256 cellar: :any,                 mojave:        "db623af5b425e866861c679124c096827c7ca93110dfe4509f3debc7aea82e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51a683af64d00696c61363559f5244c294f3db73982921e2bf8c30fcd7f8d655"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.8.tar.gz"
    sha256 "9d3f3bbcac7c787f6e8846e70172d06bd4d7394b4bcd0b8572fe2f1d03edc11b"
  end

  def install
    # Set up the influxdata pkg-config wrapper to enable just-in-time compilation & linking
    # of the Rust components in the server.
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath/"bootstrap/pkg-config"
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
