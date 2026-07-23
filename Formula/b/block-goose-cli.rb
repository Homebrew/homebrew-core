class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://github.com/aaif-goose/goose/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "507c7edc40cc721fb8751bcbc20aa9a5524d299867f69922880d04277b6fb6ce"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "941abd59a1ccc8f6a72c0cd21cb5e6096a1d7b5a688aeb412ad4969ce4b46625"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26527665062810ab792cab2aeadb921175aca3558a8b838d7a5804a0181ba28b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d89bc22dbfa7f95eff035ff89712a7f6d0fd3273f22f5796ec6a0fb5799c9858"
    sha256 cellar: :any_skip_relocation, sonoma:        "a77d4e0727bd8881a5a25d1c64332d8261a2fb347bf3c69c0840405ffd67e972"
    sha256 cellar: :any,                 arm64_linux:   "8ed30784a08b10c82f5a65d52145190253e9b74da1ff28b15d3c2056b5e6303c"
    sha256 cellar: :any,                 x86_64_linux:  "5201172d621994367eb9089ebea0717a4d1c2e26268553cc0d1123981efed5e2"
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
