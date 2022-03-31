class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.28.0",
      revision: "32f2b505c52331b494018fabcd0468687d0d8199"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b0128e71cf6d350e431fac6b7a9edb5629bd50d5cd10e4c721560fb408e4060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e049b35c22587bd4e101e553f97d573775e68c4c7cedb091df6f7616d8030ac"
    sha256 cellar: :any_skip_relocation, monterey:       "dc71d088b3ddf2667d6c036856a472c2d6f97e9cf9330ddb031c915fa4acb4f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "12011fb93c6e4464e437bf705d406c7c30ac6c96e8138a1da176652d866ee1fc"
    sha256 cellar: :any_skip_relocation, catalina:       "a2fa8b20a59e2de7d5e952d022876369ba42933f23202aaaf8f74fdd81fae903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "836b47cc83507ff590af3ffe0b44fbdfd12e17ebe5efe87fdf762995ebbf7d17"
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
