class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.19.0.tar.gz"
  sha256 "9409ebb3b77353c692bc791c551268b657b3e96d4eb1d3b815cebed724755503"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d44f559f7fbea1ece8f172cddea17c039cc698d11a199cc890e906fc2ce4d5eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8b566e41e5cf1b5dd3a2302fceb10df99597f9c8cfca6ec615ff66cbbb42b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31dc3961f16da603b49dc0d688d35cceda624ab356133adccb366ef923980417"
    sha256 cellar: :any_skip_relocation, sonoma:        "f39ad633320bb42cace5635f979f69e413a49f3fbaa1263aeb8706c52e579bb6"
    sha256 cellar: :any,                 arm64_linux:   "213b2ac562371991c240756e35e49e5609d6803bbacd48c3275a85145a1b35e6"
    sha256 cellar: :any,                 x86_64_linux:  "f49ed036911c140a9a8bbc27fa54eaacff46be80e18a352f79d233ed37b91442"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
