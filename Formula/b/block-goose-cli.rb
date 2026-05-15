class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "136750576a096c56ea1f2066be8a383185f0e7ff0e4a5325970d547c71a9067c"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15e37f0d260940070f3348308854c89c6f76d19ba66acfd327cb66cda3ed3c79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70cc7fe457df377ebeb40f60619c936b1c4bd2861f1c5fa8180ed77f8ce54ea5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "037adf2ba148cc6aff0cafcc69a1c76726939158b1f50ae0b34c2e5b463a3975"
    sha256 cellar: :any_skip_relocation, sonoma:        "95414b0f3a72edf180f85463f49d3428c15974b90724174d348c5013d0b1f441"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b384e67638cfe36c607717b2ecf464379c8de64a4b969a875d5876e5bbb4419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b3641ac64e42895bfc8ed0157359adb9e4dd48a2822b3c8332b4df406b48b3e"
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

    generate_completions_from_executable(bin/"goose", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end
