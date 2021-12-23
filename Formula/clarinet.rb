class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.21.0",
      revision: "e966edbfb1ce025a9d43c6270f02f32a4d850026"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fd2278765d0a5304c406a915205f72dcc196655ba17d8759139f9a26bd7c6bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "915e65364c68d2f47d0d3b40aa29ea6a064a28861c94a16bd252bc71975cf69f"
    sha256 cellar: :any_skip_relocation, monterey:       "495b8213885e263e2e46660a1d9448a310f48a0fa9ba139bb2a0fc528a6825ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8d8bbc4023304fc2e8e82944e588e958099ff6cf03e49f26edc7b3cf92ce061"
    sha256 cellar: :any_skip_relocation, catalina:       "99931dc45748adc0c29ca30a183cd877e5fa49ed1074146999bc525721ba87b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45d16c5ce4f74e7a58ca06d424d0d2e887ea4470685b94cf6180352fa34eba95"
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
