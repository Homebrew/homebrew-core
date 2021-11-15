class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.18.0",
      revision: "4e04586adaa38009000545420f411754219419a2"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd61e2dd46ce40a1a3bbfcdb78a97ba3a318504f59fd25fefc35d5fdf6f0f9dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "236468814681e65cff4cd9e2cec11c4d6ddecc4cabcb650b58e75cfad2e2e53c"
    sha256 cellar: :any_skip_relocation, monterey:       "d294c2faf38663de00e5fb1f507cc9c2274bbc8feef5a19be5b3184f1bb56cc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ace0468127de4b80fb1bee09add0acd7cc0a99b4a2a7e3ead635a1e900ee58a6"
    sha256 cellar: :any_skip_relocation, catalina:       "33311a84eca9be606e3b64f587eb91a0c19f12f895b2f0c7126da68f6cd5a569"
    sha256 cellar: :any_skip_relocation, mojave:         "65f32d61dca55b4bfc209d868e744378d16d2396e90c37db168ab23c6c8abe02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1d441ee1e20513639a89fad636e0c96883d0447a7b360f7933db8d2b03c9717"
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
    system bin/"clarinet", "new", "test-project"
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
