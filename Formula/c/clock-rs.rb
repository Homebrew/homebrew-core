class ClockRs < Formula
  desc "Modern, digital clock that effortlessly runs in your terminal"
  homepage "https://github.com/Oughie/clock-rs"
  url "https://github.com/Oughie/clock-rs/archive/refs/tags/0.2.0.tar.gz"
  sha256 "9770f5d79408032d635a0eabe2cc70575b0238d8a02c9b5193dc5712a14b8e2d"
  license "Apache-2.0"
  head "https://github.com/Oughie/clock-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e841d0eb84054586edaf2751fd68365a9b745891b7f00d53cdae6258b528e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1748644542478383be20188d0719ce7340419ccf3e7f8ca4df99e2d8ffb4fcba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a725d741ed7c79f3ef610a8b9d48054b51e278745c5894d93eaeffc63b80996"
    sha256 cellar: :any_skip_relocation, sonoma:        "3364739f735631db743eab7680817e6a405f6eaa4347f4122dccdbac1a8715c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d18d53bec5e6504c4d15b2098d0288325486888d7b1f42af2aa9b40645201f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f3234a4b3c5b7e5388b736bc315686856b331b7619578c51eb9b3854215f276"
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
