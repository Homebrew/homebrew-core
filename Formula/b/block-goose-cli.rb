class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.31.1.tar.gz"
  sha256 "717319873dbe9eed1ac2c533ba4eacdf8040d650449c6eb159f42a695e5597fa"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67d52a3853025bcd915ef7958d2be27875ee8eaf49bc0d2c81f526e9ac02d70b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620d2142fb473f1f52eabaae65ee05ead6f521a02fa1102a86404224098a9089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28e22d3f72c55500451af412916eaeddac6a21c30783fbbdda7731c430320c75"
    sha256 cellar: :any_skip_relocation, sonoma:        "94af7c2ef21b6c7fb0cb9fa48db23042671093ce1b81b38fe1d7b321a025d1bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b1d66f68ad1e6e848d4f2f9f7bf2f161913a0dc81695c869ea1462db8147429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86607d52378ba2f06ee258e2558db288c1b43ecd14a4dee12688ca792fd6b9b7"
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
