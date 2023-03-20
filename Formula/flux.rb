class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.193.0",
      revision: "726bf0653f99083a7486fc00a2be6abc3f859050"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ab5d5f36b151e5e9d855d93702e5dd85ba1614ed0168e6230c430d17f6c66802"
    sha256 cellar: :any,                 arm64_monterey: "59cc0f2e8e41bc70f4466f27cc3b000579bf51caeec63ad6ccaf2e5113029e3b"
    sha256 cellar: :any,                 arm64_big_sur:  "76f8a0a3e974e24b3e38c9567f108920e85ba7a31972f22e366ac4f1ac4bfe4a"
    sha256 cellar: :any,                 ventura:        "5b7bfcb200c2f27cf18fe987c1ec3a198df4e3c9cd1c77970b29b9fe3611ac76"
    sha256 cellar: :any,                 monterey:       "ae7ed966bfb92e22ab0c21c6e3e82e3e9a901172b39168efb389ddd8bda62fb6"
    sha256 cellar: :any,                 big_sur:        "e7f0e8ae3025febf381ae614d99ce71d6ebc07dd44df4a1dc683f1c2a1f9d002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cf54299f67f454a9b25cbc656dabcf502868292d7418b78f0c59d82e4cbc4bf"
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
