class Brush < Formula
  desc "Bourne RUsty SHell (command interpreter)"
  homepage "https://github.com/reubeno/brush"
  url "https://github.com/reubeno/brush/archive/refs/tags/brush-shell-v0.2.23.tar.gz"
  sha256 "e1ed28bcc77fd58a8d3927a0409d6e31adc4991b1d54f567eeb804b37cb0f45c"
  license "MIT"
  head "https://github.com/reubeno/brush.git", branch: "main"

  livecheck do
    url :stable
    regex(/brush-shell[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8395daf5f869b07c9fe0bbc6a1c5863d0e9250b82f01d28fab1da56977e028d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "388611368e7fcee5e28f57b9fe155d0ca0d3fc68e6a9455d02819a426b07a009"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dc37e66986bbcbdc068030a9e6f8119023c3a1b804acf3e17e31402b3feb556"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0ea9343fee1abdbc901c57f68d30c28a339e95ca28b62176fb94e932cc47dc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "82a63afb63f7bacd4cbdf269edbf589ece53f73650ee7d805126ae0a0e2589af"
    sha256 cellar: :any_skip_relocation, ventura:       "2776423f8acaa757911c23f6ed00e1dfef33b8df2260cbae1d167dfeebf732c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5774b9e24629eff1d65a4b6a2331cc8b109978326215ef8442ad16a6a02521ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d7e443de2576ab6a888a3972bece0ee694a79334d94bb31b31524e8c7b44778"
  end

  depends_on "rust" => :build
  def install
    system "cargo", "install", *std_cargo_args(path: "brush-shell")
  end

  test do
    assert_match "brush", shell_output("#{bin}/brush --version")
    assert_equal "homebrew", shell_output("#{bin}/brush -c 'echo homebrew'").chomp
  end
end
