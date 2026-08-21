class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.23.1.tar.gz"
  sha256 "2799f1a2b49560c529c210de98d322c6c8a30f79078862c0d6d3c4bbe9f95695"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8802bca32b586f4e3b6d217c485bd3a6b54303c5a9cf2bc31dfd11c1c80b288"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9ec28b86a9b5416f96e43e0a5cf70ae050c39fd519f931eaa20f8b4798bdffe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a06a77a8e0b340421623d624325eeb893fb3c171e007c773907bc9f941cba2ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5a9ad331ac3b1bbcaa5daf939ad80e642be6df6cb9d30cc4065cc9017bd648e"
    sha256 cellar: :any,                 arm64_linux:   "c13b7eda98fe680f6db6f8bc39ca4f7889e65711c3c70ec06ece4e1d88af4dab"
    sha256 cellar: :any,                 x86_64_linux:  "45870178ad01038fe244517ebf19e21b3456d43a41e8e813f15a5fa432ba11b7"
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
