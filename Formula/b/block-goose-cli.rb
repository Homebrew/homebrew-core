class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.0.24.tar.gz"
  sha256 "e7d3a29e171adbc81aa6bcacaf4448114c31bf8f1bdea20ef2fde3827837cf1e"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2b6deac5208959b3f1bfa9f21acc3b680377ddd7bc3907c96de261720c0bb3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "813f4eef52e9bfe53a7489e67d995466058a1553b6f8e177f236403b0e1399c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acae77d6a4e081062635daeeb40d397c8b2b9b41a8715ee43c95864f85cc6b79"
    sha256 cellar: :any_skip_relocation, sonoma:        "e69259acb8a1cdab32b50d6f79bc88f101c2b8bb2c184be3bc27885d16ca758c"
    sha256 cellar: :any_skip_relocation, ventura:       "d8e94e7aaaa27fd338c7789481381fa0721e8430dc7d1c78d0d99aaf365c84b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec83d77b15e8e0d93e2243c2f549c3b1a6e9991062e2075b66361d4efc2f7e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00949f4d09748b08901feb07e6428edff38e50583f0f808dd6e8c4380e62dbdf"
  end

  depends_on "pkgconf" => :build
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
