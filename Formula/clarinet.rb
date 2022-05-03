class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.29.1",
      revision: "c403059af09f4eb0303d488ff048aa39f082fb03"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71351441ecdc318d469a672816eabbdd322f0d3957672f459e7332dc34e50753"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d051bfee28eb10fa0d5b81aaffe558ee5b370d61360c0114721690b569486455"
    sha256 cellar: :any_skip_relocation, monterey:       "8d26991036c0808a7d1b640af815b0419657c58fe7239b8f48c68775f9b023d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1daf359345f775af61283caa452db2f23cc1047f1ab16d4eb9b0a3d25eb97dd"
    sha256 cellar: :any_skip_relocation, catalina:       "7c61ebfd1ad669c91a6d3030da18a5984bec66f1b66d6753209d0082c59e143b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20f4c4f2d5579bd3b6a87452d289aed3e96c883af0c2c11329a69a99b9f23ca7"
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
