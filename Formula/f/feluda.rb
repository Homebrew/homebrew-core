class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "c78b3511e09ea3681eeaac5bf84a128dfcea594d0af4d4b2ea8cbd6ae3ece74c"
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
    sha256 cellar: :any,                 arm64_tahoe:   "cd19318e96fae63e531b77fe85d12bb8e40eef2b9d312877b5456dc192ad8e99"
    sha256 cellar: :any,                 arm64_sequoia: "85a73cc0b5e89eb4faf1106e2dcfbf7a91ea209bfeeb0121feca711d9f3a6b17"
    sha256 cellar: :any,                 arm64_sonoma:  "c3877bb3fe92ac0d0768e6a6acf524370b65bedbd122eb96cd2413c5975c39c4"
    sha256 cellar: :any,                 sonoma:        "93ea9c385e42f5521d55c91752e19892d0eac93be267567635bba93ebf2365c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cffe5b12991b6e80ee4a06ed22b0a6ce9eaac1dfc4f722a4a4cdf839c230cb0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aaa05c7034ac1a3a5dc5348aad55447f8d2bf8458223944aa0d9160ede0137d"
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
