class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.176.0",
      revision: "05a1065f6b898d5b14fe1e238d7b77d780c6bba7"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8a8c0f4e13402fa91eae21e3bb24ced6506075ba3f93bf08c6a866e0490f7962"
    sha256 cellar: :any,                 arm64_big_sur:  "08b546d2cc13be0a5d2fbc53763d1045123d43678c89cbffa7fdbe3931962dae"
    sha256 cellar: :any,                 monterey:       "75cd0611c1626b2d25fa92903d71901c8dec7b9f8db5b8583846aa743750f749"
    sha256 cellar: :any,                 big_sur:        "5ab1b00659c4151f96522eb0ecdb397343455ae210726d8865eb4bd265cc1b82"
    sha256 cellar: :any,                 catalina:       "8292917d25155ee7c842432b648cda9291fdd39b9e8f8c8eb636e415c17a9010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f556547477e4f689d58108a7efe36b0ca3d358cffa4f45ec4639214faa69849"
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
