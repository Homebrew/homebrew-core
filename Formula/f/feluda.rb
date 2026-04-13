class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "c9305dbbd25b35083d0458e60e538d038d0c646738606e9ba1092b84a8c3471c"
  license "MIT"
  head "https://github.com/anistark/feluda.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "769cc7fd5adc675de3135dc05b0d98bd546e73d074df254059e0112370bea5c8"
    sha256 cellar: :any,                 arm64_sequoia: "f5730d3804c63681aa62df7e95ca1faae037b0203cffb6dd0a96e1e67dc79715"
    sha256 cellar: :any,                 arm64_sonoma:  "0828e022fe411502f7e6a22b2f06e1e6c2ab8091b8fee43520c245ce1cf69499"
    sha256 cellar: :any,                 sonoma:        "2cc81bb146fda4e4a103797ce3acbd62ab09873f164328095f3b62771e9f1b43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7d7c2e37a2734de9e12d011fc29e0a5291253081c880b8256f7cc5da4339856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81a4ee5c0855935aebba6cce98214a8aa5cc5128644c492fa1fc6f82368e0b47"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match "❌ No supported project files found.", output
  end
end
