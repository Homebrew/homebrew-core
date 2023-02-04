class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.4.1",
      revision: "2fd6d9598bf83d31210469ed7e6bf49d9a614db3"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f2963e1c9290773fae1d9d9560ba0b0cefb62cef4976620c20b199b2068372b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b930aa0f9c0f227ae000b8314550b0af8d6aec5c8082c78d6cf71776f841f2cb"
    sha256 cellar: :any_skip_relocation, ventura:        "608351e4a562d326acf41f2773294334195916e6f86fe9930c91a3c5a142b413"
    sha256 cellar: :any_skip_relocation, monterey:       "1399b2c9413685fe3fd0d8544c1182a6c018741b9cb1b263f29fe2b3a3f936ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "d597fc4db7d1b2b8fcb988555d0d888b10614be997de49ff00353ad804270ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62c2ddebf67ca293add91c72a50372269eedd199ed6e040ce84ab8a78fc04bbb"
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
