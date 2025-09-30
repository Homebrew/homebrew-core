class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "12f704030d3fa1480bb02430188e1a0df484333d3889fad79bd23659f86f7b94"
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
    sha256 cellar: :any,                 arm64_tahoe:   "443824f758dbb3e8ab344d6a95bd0a606d864be5f4beabf56101815c6cfe13a2"
    sha256 cellar: :any,                 arm64_sequoia: "56bd19339ca0c11c8a6a49d6ac4c46efbdadb4a42460592302dfa00c10b05968"
    sha256 cellar: :any,                 arm64_sonoma:  "35dd7edb82bd2bf265a82832c7f0f870a9f3696914ac363fde282751081d3de0"
    sha256 cellar: :any,                 sonoma:        "fcf86084a256c48b6e60046bf4adcff36e5cae8bd433de26a40674204a780aa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdd73c7264b0f2b8e608b5f0609aa57a4a548b8b80b25570a812d82957427463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ea07a9b0cd876a198440e44962096a4380f3079a0d25bd2f49cc9db10b7a2c7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match "❌ No supported project files found.", output
  end
end
