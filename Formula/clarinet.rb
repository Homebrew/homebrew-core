class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.28.1",
      revision: "7e57cd2e0202b90a0d49b006c6407f815b4c24c9"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be906bd20dbe826ad6ecad11064f1c82f07613cd0de1bc75eaececb51d64c33c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6025e09faa50529e63a44ed2ddee65a55342a74294a93f6bff6f7efd89d47538"
    sha256 cellar: :any_skip_relocation, monterey:       "94577748579d7efdd9c1adf801cc93cbee27e56d950b6415a475b24b3f278b69"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7f073f06c9bbc7031364ab2d7c5e279f6d76ffcdf65c62b564ea98b8a3c6d8a"
    sha256 cellar: :any_skip_relocation, catalina:       "c6b5de5b41ad66584f71524458d89be035f736112cea3d81ce991aed3e9b2ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c8d5de6705b377fa2ad38926850e0bfe785f0da7f028e5333d964b8402192c1"
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
