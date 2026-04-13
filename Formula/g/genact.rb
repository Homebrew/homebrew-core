class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "07d62d0c7a41e83bf4ab8b76a1c0754556697faf5aa023b4e34906ff52323a7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c8aa46fe815cb6071fa2d2ef972e90f8cff20cb20d9ac6f1bd7f29c71e58349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c2e5db24a9ec0cadf2af721abc2dfd27313f99fcda417f6175b0740113d0332"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d7886757a4c9f642ac48430ed90a6fc639796a85c476e984ffe3fe6322de760"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fae2a7cae987cb1cfad8a48fa42d57b68e6760e767d2beae851ccff0d337201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e88c678ec203a1dbbb34426823d2a38316e51609756b20808ac4953ffcf69917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef6ed32cd4140f969d859c3f3c46fb7e39facafb1b50430dd7a6b73e0e6a208"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"genact", "--print-completions")
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
