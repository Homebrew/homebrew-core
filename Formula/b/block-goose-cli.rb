class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://github.com/aaif-goose/goose/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "c8332b758fced10a5c4c7597c2bf8d6306e76d986d71290ee09f925d72f4e87e"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af4f5ea6974d5d9d7ba98203e2bf00adf04d9df173b00fcd90e4d039d08ca826"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c890f25746b496875629ab9eaaa594904d2dcb604d480d3b49e9b44fe4cf2b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e577b7274d42b3b8813306078ae89fc876ceaaa395bd116e5c0fa0a46251dad"
    sha256 cellar: :any_skip_relocation, sonoma:        "84a338a4b80102227b8ef5b5d9459e67e4505f4f0ce4eae3ea3c66cddd174c1a"
    sha256 cellar: :any,                 arm64_linux:   "8de991736f93aa6b723388db3ef5def4aa27314644a4bbcfbab6bb846621514f"
    sha256 cellar: :any,                 x86_64_linux:  "dc0a055577e0e8a5e7da3e452bf5d5df04b256e5a6ee912880324e24a56e1e5b"
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
