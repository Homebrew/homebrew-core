class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "e037a24517d422eca06575ac90cd74b46e0bb256483ecfec3b5fa2d03159be47"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27538c6a089965be86da3932d421e6b683d9ff67af50788e5f67310743be1e79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb8fb695f0fdf438dc00c3541e4ab3c07e56fbe9b0bb7d71ff18d41c983fe4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3655f70d08a512bb60c8f0cb83c8e434c90632da6bc90f5485224a792d26d96"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d703d5a1f742a474bec10d2908e76d5266ae96370e14796bcc9a33cb0aaa2fc"
    sha256 cellar: :any,                 arm64_linux:   "49de0a0aa78d3f975ba14e582e53e898dcf28aac71621d520b34f433562ab43d"
    sha256 cellar: :any,                 x86_64_linux:  "da589d399e6a19a98e16b517f8b9af1fa5a3fa0ba3158a5bf833010db6adaab2"
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
