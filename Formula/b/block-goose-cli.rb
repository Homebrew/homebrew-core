class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "611fd876d7541dfb8fe831063c9b021bd20081e6ddc978d31630ac8abcf11170"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2daaa6474160c7fa30918d6e601035739c50705be618974756db7c805714e003"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33933a026519d6d4eb617693641c502d9f6c12719bf043f4d969c3620919e7cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a79d2775502bd11ed564507afd12c0302783334bba2bdd5f3def1d2c327d73d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a7c4c6804319c576e9d20ec67aaa4d6d7be71000663fd6243dcd9c8c83a048a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a0fba9e37e2e01be3e63cee7a244e1ec16a5e2c0c66aeaed33975f5535d67f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aecb63db3cf32ef98695af891e184cff2c614a2ff933009f7e31dc384946474"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end
