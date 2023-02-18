class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.22.0.tar.gz"
  sha256 "8d301052b08421a4ef805b47e135fa76fa9848f19c17e396592cf69a793e4dbc"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3de2353937123db495c112c8d50374d3fb4864470b24d8798de5cc0fb930a3ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96db3fda7d77c56f8dcd10cd523d6b90c6c1faabe48bfa9facc1110c6ac0b72a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2812a8465545384a0807744fb0733b7714444a93f6504d00599bb6cdd0aeb37"
    sha256 cellar: :any_skip_relocation, ventura:        "5ace09da6b1b777cf664d8050e16f2cded968c9da1b397200e3faa1df6901a7b"
    sha256 cellar: :any_skip_relocation, monterey:       "49a5a78bdf916a2e9e7bd32e76ffe4f30b0c0e2a8f9096a8a1279928d75f8606"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcd5841ee415e7a0dde40b27758036a99a69ddca1fa501f7a99ddf5d9e9cf943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9201afe24f8b696263004df80ed069eef4be08a12e05457b0925d58e2d5751c8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
