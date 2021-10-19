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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f538c0dd5033758c92d444efe6d55a5d59b434711230d7c9b64104cd94f825b"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf177bfe14e986bf365b3125da290b2260291fe478692403cf1d040051035117"
    sha256 cellar: :any_skip_relocation, catalina:      "95d3188b4131e43005d62edd6663ae5bc3e5d7e874526550e16021e646a0aaf2"
    sha256 cellar: :any_skip_relocation, mojave:        "73348b4239d7f44c6658f16487d9a9cba477334789d1f9589ceb4166e7d23785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fa1c0b4cda58e15b8e3e73f8d03a2e4ad1220c844dd66b114e3a8cda5db402d"
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
