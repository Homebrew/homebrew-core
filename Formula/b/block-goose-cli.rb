class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "f74329c5cef506917d2b638e61d473a9c88987acde5cd04326bd9d1cabd733a3"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "770f7f8e84e326d1e270a9029754e6bb599641359f9b363972a5b58d3633476a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d850f68798536ae23601749204fa5859eabb9fa1d532a4cc47546976badb296c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2961ba0052d7d562150a797a831932e3923b9805230f90a2816c024a80c713fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fb2d6700cfdeb3ce52d67c5e5b18497178aaf2e143b903b4d8a0258bfc92d9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07ba8d0c9ac67663c2b42d7d284bafc66b3f5d093dd70f7be1bab26a96f9ca35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe0206e967f1feaf17b4f0cc5ba7cb6a94f82f62b7bfba5049fec6c624e7d39a"
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
