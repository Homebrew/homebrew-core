class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "2f825588136f20d34d39589d1c747e8d509f0c72aaaa1f6b09ce83a4b51f8f1c"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46fdf5a717cbc2a190573494dfaab6da23da91a8492aa9802615862164321036"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a19f3cf3a0b4e80eefa3dcedfbb62533914a584e83c7c6e5a3d51e95ca6b6674"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ece372a3141dbe8a7623f74ac9c9e0614c18cea0bafffa7c2baaf9de9758cd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f203884a5ed94955057e7def71485c4e307b49be6802793b4b7bbb4dfc174588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eddb4dc102265cffd0a987a7aa9855286265d29cd6f42b2d2ab01e33550f033f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e27fccaa2a33c99d2c66d3856fdc8c3e046ff4bfa0797da3ec8c7c5cf00695f7"
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
