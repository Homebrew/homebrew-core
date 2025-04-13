class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.0.17.tar.gz"
  sha256 "bf643964abc31458cc5d320ee43800b50fd5d6058458a6896489ac84d4563f57"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c7fd465d180f12bdaffd0a3a69f8382f1e339535cb588c59d5be8add4f53837"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "496ff008ee3e03ad6f89a0a99fb7bf72ded0b9453f7f0697aa1d3471a67d6420"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa4f83e962afbbc02f57c396a72dcce61450dbd9a65be648f1b228e9731ce58d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f817ec804ad60e9b21ce934e5f15f90a542a75b1e35cdc53efbe2dd88466d744"
    sha256 cellar: :any_skip_relocation, ventura:       "9e813d60a15a8be163bd190523f0b218cf371e8c9eb0e674b2f97267c297a1a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b37b81f0fa447181ed8d5205aaf011f677e5798fde3132b9e4db09aed0ac9cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3817b8f47942135f8c32b55e4fcc7784e6fae73fda8e185f0eceab536b6784f0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")

    output = shell_output("#{bin}/goose agents")
    assert_match "Available agent versions:", output
    assert_match "default", output
  end
end
