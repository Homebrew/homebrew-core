class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.7.0",
      revision: "63fb4d0fd670bba0f687f6b86e67c4ac0f6f3dd6"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ab0f31facd7eed3f0fc13256f7bb6e5fca0e5a0010311f02ae95218606f8af9c"
    sha256 cellar: :any_skip_relocation, ventura:       "097f6087fc02430cedab153893661e97df4375f73fe5abed03c4d13bbbde4b34"
    sha256 cellar: :any_skip_relocation, monterey:      "690780b26af223e359fc1ffc18bd10257932712937d97ea269a8dc7f55106fd3"
    sha256 cellar: :any_skip_relocation, big_sur:       "c53d055910f11755afcbe31e9d49ff328cb013e353caba25b19de990abdbc2ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ded4b86277aa926a4133e5169e5b062c57c6af7d79ef0d60a629813bd0784b7b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
