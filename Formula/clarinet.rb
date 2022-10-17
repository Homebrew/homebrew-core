class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.0.4",
      revision: "cfecfe1a35e9e9d8760451f8f3ca5ad470186282"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a720df88a5a92763ada144219da03f74235e78b4a8957de259b249e3331a8ddf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bf165e61996249009e3e887e57b594f5d5b9e8bdbc3d6056bbf5b532c29247f"
    sha256 cellar: :any_skip_relocation, monterey:       "51f7843260183c50501155e052c3dbfb6c040d4d50110b885ce5c630e90692ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "011a0491b1d6d792886680e9738760c76a88619f7c3d7847993965f2e67f68d6"
    sha256 cellar: :any_skip_relocation, catalina:       "cde7021ee1a2b981a6b384d4a53e29a9bc3058b6faa7e8fd84bb272d8470938f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86f962a61ea250a8fc51e4f1e8562abebd19f03ceae6237f73bfe5d957217bd2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
