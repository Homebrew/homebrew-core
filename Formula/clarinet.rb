class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.25.0",
      revision: "d75fef410daefc2694784d3f26a76ede54132a45"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48e423ca8cb5fad52e27164483b83adb28a82909c4d9611b33ab38f2d3146c58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea556c9ec0a6a6ffc92f99bee4191d6f702950b4efad1e7c980cc458f138d5e5"
    sha256 cellar: :any_skip_relocation, monterey:       "2c7cef2b1b5f28193716cb20d4157d59e227aaacd8a5fd1dadba20a573138a2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "09f32afdb734d153dc445858c4ba3b51297b6da8d0738372daa0647f688be9ed"
    sha256 cellar: :any_skip_relocation, catalina:       "4c49d5c93457485c4855dd5365c369489d2b3d8d4816421e7031af80e13e78d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c2118ef682450ccf7539c6c8ddef877377953a38ca362ed2b1932828d999017"
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
