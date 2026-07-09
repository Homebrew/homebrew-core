class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://goose-docs.ai/"
  url "https://github.com/aaif-goose/goose/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "1eeb0dfddbf2e5b1a850e24ea5ce9bd7681501b1d200e26fb5e3be465337c1bb"
  license "Apache-2.0"
  head "https://github.com/aaif-goose/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad979e315554a84e17769725a5fe81f6f8ea9d8b464591c7b2f81b3f36dbd6e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ab5ba09135cb98609350698ee3bbfe3f451d9a196ed5734caaad881ca04d237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f91dd505d685dd1ae5685b693b83ff0563313b4c822cf94e21b08e320848f299"
    sha256 cellar: :any_skip_relocation, sonoma:        "f30210e918483602aea0963216f5947f66a410bceffe40d72eb727d78eb25e5b"
    sha256 cellar: :any,                 arm64_linux:   "a6a6483a04d4c1f62401e612e9d4f8a4bc1b9fa45cdab20e192919018f3aabf8"
    sha256 cellar: :any,                 x86_64_linux:  "21710c96001dec88e1f39ad033b6b9d9d1d2f0575f958652ba891d918a2273e6"
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
