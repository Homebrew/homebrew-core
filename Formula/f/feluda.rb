class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "6c12366a4e7a4649c1dab127c08eda6c6dc5f5f85087e64df1f0fc2fe0c011e4"
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
    sha256 cellar: :any,                 arm64_tahoe:   "efe1948472cc371358363f6381be6b0570a3d7a781d62aa80b7058bee1843193"
    sha256 cellar: :any,                 arm64_sequoia: "de5d79fc2ce0fe70e98c33ea4869832f1aa1c71dccad7478bd7f0c6e7edde7ba"
    sha256 cellar: :any,                 arm64_sonoma:  "9787bf14ff8a67251292f5a61b9ed6ab065ed05ede8908398fc382f88786e6af"
    sha256 cellar: :any,                 sonoma:        "d265e288fef474abf2dd6a45776ff258fb679f77dbc43f49dc235e8a52c49051"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abbf292ca7e60f9c266c5356f596a81e15282e6a1e9c6837835d259a2fbe3481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5af1403ae49659db3bfdb10b3d782075ee767e60bb78c06965ee9ff763a5c895"
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
