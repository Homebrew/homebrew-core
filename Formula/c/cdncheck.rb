class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.18.tar.gz"
  sha256 "ca7f78dbbe01db3a679fb3ccb8a49609f28807f7294c7c2cb425442404ef0d4c"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "654f687d94150b49cb378f345ea752e890dbd9918adf8f2db557ddb6ed2a99b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bca786e0291823bde3334bf00eb9153975d8614e14f4f371eaafa50cf408a216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be7160d5aec4a0d38164177642e2fd88256e8c6a198009a93f4b66238b5ce53"
    sha256 cellar: :any_skip_relocation, sonoma:        "f58d24d3c2621891f71816b7e8043d7b69f2d45d6b46d3f5947176967f62c1c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1ecfa7622aa0bab39b7cf4536b21cf6a0040abbc22fb38b61bc0b9056c5fcc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "763e5c708ac33ad2f76c746e6ac0cfb469779f04df20782d6865da906db18254"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
