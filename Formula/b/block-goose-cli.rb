class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://github.com/aaif-goose/goose/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "87a61407cc0c10642f927d45708278236dc08ac3706973723dc06bd3df0ea262"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6115413f93c1f8ff992b2f723e8e97a7d9ea24134af3982ca6abc179376a595"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b67474bfc4a7e3abfe906cdce02489ca2a348068302f7655a95045f00d42475"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8fe0e8be9e98668125fe8a69dc0653ef9d5613150e22b38f458797a1a108df1d"
    sha256 cellar: :any,                 arm64_linux:       "373d091dfb182069aa59096bfbe971f13f53482c40d18100523caa70f2137cff"
    sha256 cellar: :any,                 x86_64_linux:      "314a0ee2fc94d6c42a028c127d6cdb640b3ec8798081f4a891a53868fa79d50b"
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
