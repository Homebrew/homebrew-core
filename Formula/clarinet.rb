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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "742cde6cfd4d462818aa5e40b77f0b0488290cd29534583c6252abb6fd9c7165"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1f2fb65d1419187eaaf07ea3b273557557b08a6e80da367e064892813672d82"
    sha256 cellar: :any_skip_relocation, ventura:        "653bb041ea32fe58b4777c394f7cce7752e6fd95cd25951fb59ad856f8a92f23"
    sha256 cellar: :any_skip_relocation, monterey:       "d4e0ecb677d687e24a82d20e5071e3da85b4fc40fdde3e474c59ea5a6ea06e3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "261a42872ac93fa95d39de00654187b0882d3df3b695e83a7f526183c41f8f2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86c2dec6123ee9842d7aeb32a5ff2b068d8d542b19aaf9611ba00f574a3a0d73"
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
