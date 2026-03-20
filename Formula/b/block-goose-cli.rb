class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "b3cb08206a88cd177663e3329881c5273e3082b2caf4566444d15f9650c2de64"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "514755589a9357206d0627a31712bc38ffea118e2ae1d5a770404034b3304f85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c834182832a69c8501701350431b339380724c22e3a24de620599e3710e35c25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdac1572ca9ad70869b43a15e478a308174c895152343106347e93fe98e70210"
    sha256 cellar: :any_skip_relocation, sonoma:        "07ea8698faeca2f2357c35191866d5705927f076c2d10ac21ff1bc766b5c1750"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "204e30a279d808a57a4365e2aa8ab856a383b2033dc554834a07511b660cbaf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c2a7c6063fc717666b204a932709dbcfcdc59a2482aa8b330f056c9bf3117c6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end
