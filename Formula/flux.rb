class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.177.0",
      revision: "1715d9d72a1f0f4938abf8b68b2a8c80e11c1dd8"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bfb009ddf6760c6bea51c311fca87fbf933eb829b9a791acc675e33260801122"
    sha256 cellar: :any,                 arm64_big_sur:  "0de8747327a493494a9e5bb8aa59ee118d623b0bfe10dd0ee51e161ae06f3e9c"
    sha256 cellar: :any,                 monterey:       "01af52fcb636205e0e9ac651dc6149f2de4bd1cccd198c9f604429d7c3524bd6"
    sha256 cellar: :any,                 big_sur:        "4c36bc687b068ec835770228e2d7a81de046d94374566ebd6295acc29e4e7fee"
    sha256 cellar: :any,                 catalina:       "305059cbcd24e9c3a7ffdc3b89b225fb89798eaada7a4599c84a198c7522d8b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "515d319422a06b3e73f511f299b51be8355d5b538d9336d058eb3033f25840b8"
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
