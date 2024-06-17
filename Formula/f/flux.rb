class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.195.1",
      revision: "da04c3f0fab9eda235a2a7c3522348e1b3941aaf"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4f8af5b2ff90ce96ab45683503cb52be18346e72328196eb6733c7c9083ecdf2"
    sha256 cellar: :any,                 arm64_ventura:  "2bf71cef2b5eedfd4247ff3f8e1a383c02aa4f2843d630ed4a8e92bb86e0a682"
    sha256 cellar: :any,                 arm64_monterey: "0fd5e630b46f7ec1cc7b3a26b571514940d1fcba9b13ab0d2e5edae4a83e50ab"
    sha256 cellar: :any,                 sonoma:         "670510e6b726a176ea9fe4dc7f45e2471929222ce9a2a3d781cdb030c953bf9d"
    sha256 cellar: :any,                 ventura:        "d3274e6610577a57ab25a3c2370cd9117cd210a4c6c97c4939ac0842b024169e"
    sha256 cellar: :any,                 monterey:       "5ae3873eef4b65ec247a955d1be169811169b6a66b988822f2914cf486a593bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e795baf060ecd82bd2614e5c5d21077b66192bf704575c78409f45f24fa5551"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.12.tar.gz"
    sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"

    livecheck do
      url "https://raw.githubusercontent.com/influxdata/flux/v#{LATEST_VERSION}/go.mod"
      regex(/pkg-config\s+v?(\d+(?:\.\d+)+)/i)
    end
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
    (testpath/"test.flux").write <<~EOS
      1.0   + 2.0
    EOS
    system bin/"flux", "fmt", "--write-result-to-source", testpath/"test.flux"
    assert_equal "1.0 + 2.0\n", (testpath/"test.flux").read
  end
end
