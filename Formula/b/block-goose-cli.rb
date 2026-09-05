class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://github.com/aaif-goose/goose/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "0d10aab55adcfa81705bea7a543d7fab0203be9b937ca7d4bc895617a85224d7"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f652c6660a41e8ca4302d9d7aa28a54505056804a12f5be7f2d8a441445cd68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1546e478bc0ac52807ec6e015b71475c5ec3935564a6c5924f2fe8bcf98b15d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5af90d2e2ea2b6d81105a854a8456a39a3f0e1538d48cba717daa5b083177b2d"
    sha256 cellar: :any,                 arm64_linux:   "3969f4e58edc127bb04229cb80d3aa645b849a9d76ace78fc2fe781895d21f9b"
    sha256 cellar: :any,                 x86_64_linux:  "74c9882af91055a2c4b160c1dae6af20ed7509abf85b93575ebe3433ff0836ff"
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
