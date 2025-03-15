class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/1.5.2.tar.gz"
  sha256 "7b79f5374bb6b1b1bdb4e8f2bd0bac5d52a66b4aed58cbd2fae7b6facf153701"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bde60255804528b16024a0a5cf6a2374c7b4c7c66704e81226d553170149a523"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7de367d5168b7fae342d04d23b36e64d926c428c40c379fd19b98ddd9465d154"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e866b0c1a6fed729999e9f589d47483cdc1da0d8b0bb3697e0a8d8a2295b336"
    sha256 cellar: :any_skip_relocation, sonoma:        "458b17566634cc889dd0da29a915671d31695bdb64fcbdd62b5b37e4823a3118"
    sha256 cellar: :any_skip_relocation, ventura:       "3bdf9918d0c175880b5fe45e5612e9434772e0da0367723a24d850362fa4aad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3433062dd336c05b3dc2ba8f6e81e14bee38ea01014031a119329930df9f745d"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match " All dependencies passed the license check!", output
  end
end
