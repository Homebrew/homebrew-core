class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "57eb2d5cda1b83e83d775e1c61ee1908339f862aa155aceab1e8032a5fc6bc57"
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
    sha256 cellar: :any, arm64_tahoe:   "f7d6b5bfba284f8e2032d97cd96ba27d81d69d1f916d15187f99807ad009101f"
    sha256 cellar: :any, arm64_sequoia: "219bfa95052d7c241f49a2a79864795ced3df29904489e2d1b473b6bd55fe0a7"
    sha256 cellar: :any, arm64_sonoma:  "ba7ebbda0f6680adc70529f76ac0b3594b083125e032a16f5838ebfd6201e5df"
    sha256 cellar: :any, sonoma:        "e819b4248baf237b22440d8103cce01178e348971dc991f9ee58c4039119dfc7"
    sha256 cellar: :any, arm64_linux:   "190481ad31c7ed2451aefbab01195f91165d46ceaa44d300828a3fd1d8c21ffc"
    sha256 cellar: :any, x86_64_linux:  "b1109743d463de3bf7314229b248c561d88563fd59499af17e3fe88d61a34188"
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
