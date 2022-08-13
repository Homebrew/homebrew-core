class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.178.0",
      revision: "d0ff2cfbd20474784159cc90afa8ba577c2abd5a"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "326dbadb6dcb8819cac575ef8690336d5407e8c5d6f93bad6833b57d7826eae4"
    sha256 cellar: :any,                 arm64_big_sur:  "e119bc3b0a8ef36c261599f61bec6ea7fc6b05eb6c2e54dfc3b5ddbbac25b15b"
    sha256 cellar: :any,                 monterey:       "a8c2fb160b862501b10f5f521b4746b3db8de055669ec23cfdacabedc3227aff"
    sha256 cellar: :any,                 big_sur:        "220a1cbc3dda21b18c2619065d919280793790141831d56a75e63b6b4ba5e0dd"
    sha256 cellar: :any,                 catalina:       "a0947bca770b63cc5941fefc9bae3eea01dabcbbe09777cbd334fe8503a9c4fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b989fb69a75ce06d8a320d6210e5899e8ae13be98b57dc1807c7b9867326ccf"
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
