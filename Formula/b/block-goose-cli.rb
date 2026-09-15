class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://github.com/aaif-goose/goose/archive/refs/tags/v1.50.1.tar.gz"
  sha256 "a9ecee4f52b3f695278e1810876125f145a0707afed179416f271fe24668af73"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f88c0653892d32938d30191068901b9b8ff3ad4ad22bb03bbe1dd576470ac573"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "24bf01fc6de08012863f1907a3401201287d543b7f6033173be68c972e2c3846"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ae4052ad73e2d1199b801730f2b4dbddc4d88d0426b00ad6bc0bdf7d9e01abc"
    sha256 cellar: :any,                 arm64_linux:       "da49ba731a41a23455d60641cae24940433bf8b8b0fadcafc1fbfe77f637e814"
    sha256 cellar: :any,                 x86_64_linux:      "21be568b26a4c4aca39705a045c757f647bca4ef79582a2e47d9bbc06f3e1ec4"
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
