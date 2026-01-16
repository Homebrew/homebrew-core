class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://github.com/foxglove/foxglove-cli/archive/refs/tags/v1.0.29.tar.gz"
  sha256 "4a62cdec44de68b5aa0c90a5627babcb62404be0bf204ecb9967a033adf0faa9"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32aaf14f7e2285b537ffca5b93207e4c53a54f115e227bd4baa968ff4a313a49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "432197db81e8205381b96e47d25df66555392cbd27ce0febda7d221c76ac9bf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f3400ba8ff19c71b8f73ee86251569489b58720dfe6e18d0d02101b3b7ac4a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "abb82d53f98f8eca215fc0117870abaadcb7051def536d78d3821377654d5e02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84585943329cbff1b9a9c7a7d24679b52bb0da2a198b31edd058e6aff955cfe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6d31549e92a6d100243cadea8b175068a2b1ecc3e54e473bc21a20b63c6957d"
  end

  depends_on "go" => :build

  def install
    cd "foxglove" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "foxglove"
    end
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end
