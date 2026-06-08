class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "a64231265f953dbdbb0e7c2eb1b680feccb7d8212613070463c8ff3cae715e29"
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
    sha256 cellar: :any,                 arm64_tahoe:   "6c6804222ab3cc0914809b82911d213f5511992f9b9e01d624a0373e253bc7fa"
    sha256 cellar: :any,                 arm64_sequoia: "8da8c437a6c39f57a104fd3926ace2257d481ba63a8c88244464c8849d8e45d1"
    sha256 cellar: :any,                 arm64_sonoma:  "ba490fcdf5d46916b693e56d6cf537c0f8860707bec018dd85d9c21df075536c"
    sha256 cellar: :any,                 sonoma:        "41992335171e29444a2cbed370053199a8281d947ecca64eab26bf4b96f0353e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5020659abd9c2081821499ccc9533926c1df2607d1b058c7a70c36581b84344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40706b4db091cc350912a1e45dd6b5dc3d0f801287fefdd87794f74f6515aa3e"
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
