class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "5ed0f2c05f35ab4fcf65130a4c14bbad192feb0bc56f318b7a42cd4e302dc801"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b2fa6a4857919fda830e5ef571f45ebed9c29e1fcb74202dc76d203eab72531"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ec9d20d0532ec0ca5ab409c4524dea98590bfe087665d14a5b477de385b31f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff24a0d9c9a01b08f05efe29d9ebc693c9144d4c0a917079cbb3123f39721744"
    sha256 cellar: :any_skip_relocation, sonoma:        "1beaf09089f06d55ae22e6a8bd243d15444a93ae6345217576d26d406e0c2135"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8240e1908cd94aef3bb8cec5b0a87f32e53c128a92768f4b2990ec2bd0ac905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5511de9459b48d3d0ff14ca6e0830bd010f757c6127316d83a95114eba7f382"
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
