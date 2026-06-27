class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.41.tar.gz"
  sha256 "ed4b19a543e82a17c295e49c5cb9287a7ad2f0cc5ad3571dd572895c50a8cad5"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05ae620416f89cae42d099a1d9dbc6621a32476603c14581a54d4b14d7ceec68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da5d1f2564cc71e3cb6982afdf3ae767a457ad689ef5eab0bc83cab73c5a0846"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad01e54baf685f522e6e3fab04cab6c2d5985026eeae0cb6d58784a4c564ec8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bb8230ab37e4a227db1af62f23a04682704b21ad5067b1f50b42084b20a3f46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10c441e287454e58f4a6e2d82e6132eb41ed34d4293a1257cbf2bf41f30dd54f"
    sha256 cellar: :any,                 x86_64_linux:  "dda2ea405dc41aa5ffca08fc51b085a1e458c4a4292fbf8fad3ee9bce6d5ae11"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
