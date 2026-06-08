class ClockRs < Formula
  desc "Modern, digital clock that effortlessly runs in your terminal"
  homepage "https://github.com/Oughie/clock-rs"
  url "https://github.com/Oughie/clock-rs/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "cb344326f7ed45eb252d74d27d35cddf61b8df9566e60f25e129da696e083344"
  license "Apache-2.0"
  head "https://github.com/Oughie/clock-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ab9169308b9683f0c426f2b909c6f2d7893df39f9c1cb6b6e3a53d9c1cd6791"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80a2f8797600837578f1eb85e630f3637c6b93107c7a3686b55d1616cfa393e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3ebbb592aad42fbb2b49d04d35f8c49c8a38e20b1dfeef7924e939bf6ed50d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e0c08dde682062f47e8886a68a8e5766b124f267610860998f6986818f3e616"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd1d3f61c00011290a1b46c7fb1655a9777c719d13a703476519dbcc6a552de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fab64b9d9037fa76b782bbde24cb59f80072758807cc227626e61b1dd2358c78"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "target/completions/clock-rs.bash" => "clock-rs"
    fish_completion.install "target/completions/clock-rs.fish"
    zsh_completion.install  "target/completions/_clock-rs"
  end

  test do
    # clock-rs is a TUI application
    assert_match version.to_s, shell_output("#{bin}/clock-rs --version")
    assert_match "error: unexpected argument '--invalid' found", shell_output("#{bin}/clock-rs --invalid 2>&1", 2)
  end
end
