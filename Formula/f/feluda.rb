class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "67f2c71fa894480d9ac8d03abd786b34be07ad0c7b117a40adadf5c8bd98168f"
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
    sha256 cellar: :any, arm64_golden_gate: "b822d0b5dd4903d301bf4eb0ea6bd10e0920d0bdfbe9011372b007404dd4ed75"
    sha256 cellar: :any, arm64_tahoe:       "bd29cbb04b417ae0cd4b4819867e09ead478363ecf44d69c8b185d1cc41a55e7"
    sha256 cellar: :any, arm64_sequoia:     "bfc75246c9b5503b06628d7adfe8e9602a3aeca0559519c359840ea03d1abbc2"
    sha256 cellar: :any, arm64_linux:       "2b5d291a421bc04114aac3b6aa84a273f793762c3e20875ceda9a058925fcfa8"
    sha256 cellar: :any, x86_64_linux:      "516caafa476dcd77ed450b3f2ea0e190fdbd496d96a5631e988038f954a24b7e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath}")
    assert_match "❌ No supported project files found.", output
  end
end
