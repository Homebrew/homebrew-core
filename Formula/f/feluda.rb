class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "2a869288fec7f6edad343aca29571215c94e7b47eba93e93dfb9f3ada8ede2e3"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f8bda65949c192b41fc8018a393bff44fce7312681b70a72dff419f3fa32d8f7"
    sha256 cellar: :any,                 arm64_sequoia: "146ba34a18edf47a4eeb090dfaa09a17c175fdd5e2f04fa110c4257b8d61d1ed"
    sha256 cellar: :any,                 arm64_sonoma:  "e0ec1d5948f74eb60ed7830f214bb61f71a7b1dde2a8f4bd0212cb1b0055585a"
    sha256 cellar: :any,                 sonoma:        "90fca6ae9d8936959af23b3598763d510ecc285326a0606be0f72256cf7c0e02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e28cd22412bd283c1b295950c417579d210d2e6026556de84093d5a37cf809b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4307b81c8979bb3699aa88ca68c6dcfbd1d9f91e14eea2ca0a49534346dcf51e"
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
