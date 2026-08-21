class CargoCache < Formula
  desc "Display information on the cargo cache, plus optional cache pruning"
  homepage "https://github.com/matthiaskrgr/cargo-cache"
  url "https://github.com/matthiaskrgr/cargo-cache/archive/refs/tags/0.8.3.tar.gz"
  sha256 "d0f71214d17657a27e26aef6acf491bc9e760432a9bc15f2571338fcc24800e4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/matthiaskrgr/cargo-cache.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ae58970c1cad67cab7d1c1ed0b354989d34eccfcdaaead753754d12eca1aa2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "133e58a5df245b9b9dbbd403e1046c33783a29c682abfb03a6b9242da7187c15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0ad53eb576c0924d411370548d093113570d8368c4f19da86e31683ddb14c86"
    sha256 cellar: :any_skip_relocation, sonoma:        "32cc1e6a496f5a5668f098b86af3d456412a7c8066a739aa62e9cb1c80c9d47f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64d31e9da185cca1ee9d2ce9f27bf9a0339d00abb25f3e7fb0bbc7b79a4b0eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ba80fe970d805ce31c1df5a8847af3d515d0bc81df6d142c5d287e7b923549"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    output = shell_output(bin/"cargo-cache")
    assert_match "0 installed binaries:", output

    assert_match version.to_s, shell_output("#{bin}/cargo-cache --version")
  end
end
