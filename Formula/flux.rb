class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.194.1",
      revision: "8ad36639ede4826242455389fff4810adfc4e884"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2b1380d9e94b5cfdd3b6725489bc1ad76a44f3ef5dff807f79211d9558afae98"
    sha256 cellar: :any,                 arm64_monterey: "0f1d5382762425df204285a09da1171c1736b77060bc6b0b6c1145d1ebdde32f"
    sha256 cellar: :any,                 arm64_big_sur:  "dfe3391c72812d9792f0989cd1af8ebcc67512dc18b2bea8fe4ffddcd912c14a"
    sha256 cellar: :any,                 ventura:        "558a4469054ba24d5b30f9fe9e5069de24109a409d2185a1a2584ba2b63952ed"
    sha256 cellar: :any,                 monterey:       "b7b1533ce0e24bd7de1a84b57d6423f8df98f5c2826882c4548467b7fc855d40"
    sha256 cellar: :any,                 big_sur:        "a33a95221b3ddb6b49568aaf375ba58fbae4b18be72e8d4d3bb81836f444fc29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e644038749199930f89d40de831c99087f6fa1a1a446602d26f9dc560b4049"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/v0.2.12.tar.gz"
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
