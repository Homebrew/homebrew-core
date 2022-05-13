class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.30.0",
      revision: "79f8a4f94e3941193d96c3416b2c6e916a62f1d3"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae57ae1348e118741c397a560086df9b276c1bcd4cd7e71062af4df644f7c148"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2f3f3ce1d3571419df9e1238ff0bf901aacf18760d096e27c816d715e0e8aef"
    sha256 cellar: :any_skip_relocation, monterey:       "beefd15208ce27f8bd852a83135d28a18c13f15abaab2f61c2964f71c8a7f877"
    sha256 cellar: :any_skip_relocation, big_sur:        "e63ed1c1e14271ca054869151fa056c529e0e30f508161cd6fb71626fe3eb327"
    sha256 cellar: :any_skip_relocation, catalina:       "e36293ab13c000830cca6518e484e5bc2b30c078c8645c4860aaff5b6264fa2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ef2c72c44ae20657db8d6e9ca824661790317e6ed2499e976b76ea9198938f6"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
