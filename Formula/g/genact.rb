class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://svenstaro.github.io/genact/"
  url "https://github.com/svenstaro/genact/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "bff905d0717cd8d5567cca3a81b718b64e0c965b6a49b119bb83b6726858e31d"
  license "MIT"
  head "https://github.com/svenstaro/genact.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f07ad6bc63cdd75cb4d147c543203ccc213a0014267933ee39ba822b78b0868"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a60e80dcf99c77d411494da33296dc83366d5eb26b8b65f39dcc0d5393c961e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75e17e2fff597f44f11b22f0abd4522b85c6c54b24facec8d5349655a602bf8f"
    sha256 cellar: :any,                 arm64_linux:       "45307fbaf1396ad104679ed6c9fa95de7267f2acbd7d2055a0718e81272decbb"
    sha256 cellar: :any,                 x86_64_linux:      "5e24b161bf245cd2a2d06f02adb3a77eb2a83d15e2dbcd52b7769360ba5ac943"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"genact", "--print-completions")
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
