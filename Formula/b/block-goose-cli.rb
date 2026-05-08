class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "d94935a7827a92a422fa9482e23c3c854787d88543758701242233fa56190cf1"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96c1d0d2cc907bcdf5b08db8a87029f96892cf255c5e1ba064ccd7abdce7478d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2fef765c9251d41955975587745517c4a50c3a011c5029b732f60b8cf31a814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e70f93738d0830815d1ad27910e898e0be1033cdd7b64bec855389c51c53597"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b69df97fe716f9d3b534cbf9e1739c8093bbec0d3a6d4485bd0875e37c7dae5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f412b57d107a57ce87fed51d43c8df8aa6ff0e727612bc379aea30d5858a2767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01c5c68cfd8c1ec8a92a32f7752a8605cb21becbd275ec04ce778d6c8692d6c5"
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
