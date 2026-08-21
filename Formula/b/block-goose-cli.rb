class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://github.com/aaif-goose/goose/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "0a4470fb0412f464528148f7b20812a2297494a3d72552b21c58a816b1f6fcc9"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4569309b6126f645d94ebc8d6999e36c1a856234658c80ebc66e1356b4a7bc5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c30a964ba9567d9eb313a4a6846b827057d80a777541d40a49501c17f9cc443f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04d14547e6a8014e366a95e3ddc3d147fbbd0f65a1dfd016fa685bba003920eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b8a6d4a94843fbac560dedc2d404ecca4a049d514ee6b5011d141ab82345e18"
    sha256 cellar: :any,                 arm64_linux:   "99d6243e3faebc62cfc8ef9b15056f1aac2ccb057855f1af1263d39bbf2bebf9"
    sha256 cellar: :any,                 x86_64_linux:  "99e5ed271ef9c01eabb40cbc986d69306cfb899edf3dea4d7a159dc06f88e7d6"
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
