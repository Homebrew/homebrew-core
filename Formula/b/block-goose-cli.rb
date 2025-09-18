class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "83aa3c763d6f2e613f748ddc7174f26f448f3bbb71edece72641b1f5fdd2949b"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e75d25a54e048e5c9633cd05f87be83cf8d01bf91b8a4f38e8ae20f89b71bbf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82634526540bcde053c2d5dd92777a4885adc4471f6e2c969960df20a4783b3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "979da8b61cab876084b78e9952bec2d7b9aede1eb41a2d837aa5860d4c42f6d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "346b3df99116347d4cfeb5eddf1944fc60517d6b8b4a774e101b69400397a0b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fbe41f01720b3d9441b46b4cc725c6cf3c2b0be1c0a6e0003794176552cda2c"
    sha256 cellar: :any_skip_relocation, ventura:       "94508aaaede18f61eacdc59352e5f3266fb2e5bfc7e9fc8b62ef9c7f7d02aac8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64ca26d36c5fd8c5e0b6912df717b5d4002d9f28c40bae98c221251a29c0cd6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cd32462767e707ee7ff631cac0205d16cabf4d6aa68db65b5de550b14aff16f"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    assert_match "Goose Locations", shell_output("#{bin}/goose info")
  end
end
