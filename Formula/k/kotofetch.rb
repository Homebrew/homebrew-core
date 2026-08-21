class Kotofetch < Formula
  desc "Small, configurable CLI that displays Japanese quotes in the terminal"
  homepage "https://github.com/hxpe-dev/kotofetch"
  url "https://github.com/hxpe-dev/kotofetch/archive/refs/tags/v0.2.23.tar.gz"
  sha256 "19afeff83d166bb31410b2fd7c69b12468f918534f22a435ce2e6e3b620d5594"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3e775684bdb03fdc6e2c477a3c8251e5290e1e9898a3dbdc57442f4d0a38184"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b93523c0e12a58145cf9df0ee72317a3c6f072f6cd752334f97fd07adc104b30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56ccc28c6f4f1ada390f26a3200a549eb0d61c055708d8b488b6493aa4f23593"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fcdd0abc7e37f3ec7d5e0475a0faead4fd1ccfc649face1ccbfee2182192d28"
    sha256 cellar: :any,                 arm64_linux:   "9046777473b6df0d00f6be6c3725d2e3b46f2c9a7bc3c5b6c442c5cccf9329e4"
    sha256 cellar: :any,                 x86_64_linux:  "50acd9b88e6b4ffc87a94a976a4db0e934a507c76e38ef6b8a828768c61ec7df"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kotofetch", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kotofetch --version")

    output = shell_output("#{bin}/kotofetch --index 0 --translation english")
    assert_match "Fall down seven times, stand up eight.", output
  end
end
