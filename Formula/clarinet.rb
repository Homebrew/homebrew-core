class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.23.0",
      revision: "58bf1f54ff741ea28039c7868527c6e0561e18ed"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "733e907177c2725ff7041c68c2dd59d07e4cf5d25d3fa67c228ca94ee7ab6a2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c6223bb4b3b303b347f8559f81b69a5a0bbba150aa88b2a860c4030e7158a64"
    sha256 cellar: :any_skip_relocation, monterey:       "1f46a416a7467040c1c32c7703ce1d89767780ddf0351d0e561206b46198e2c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "edfd863b5d5c001b757eaf99d5c3a71549c42923713fb86127d9c7463733d1f8"
    sha256 cellar: :any_skip_relocation, catalina:       "d4425a9ed64f8ad5d960c8d5813162b15d992363509ff5352da158de94966763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce3cc9cb512d66508d88e709a2564b4af2d28df61f054277a8cc5bbbb2e06816"
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
