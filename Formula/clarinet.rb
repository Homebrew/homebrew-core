class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.5.4",
      revision: "3b741691b0417d06f03b3a83935dc13808363d4c"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec950f9d964d1e2224ae82a5321dec6e1469a7cd8681a78cd6af86afe8006142"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2126a5e3d61b1322464aba0ef8fc82866233a232aca1660c47c4a895b6f7287d"
    sha256 cellar: :any_skip_relocation, ventura:        "fb5bb06bea90a384c531ed241832331144dd5da3c09b60212badfbba22bffd5f"
    sha256 cellar: :any_skip_relocation, monterey:       "7e0a5e93ce1aa2d859e9fd268b4011a67cc70fc5ddde806b9fe3c29a02fe0d63"
    sha256 cellar: :any_skip_relocation, big_sur:        "68f0a66c847951538bb0ff9a746a8b8561abd4a5a990c87253d6e45487d977a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c941e4c4ea73d1501badfb112840fe072e9f6e9601f564197b28424b867dc17"
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
