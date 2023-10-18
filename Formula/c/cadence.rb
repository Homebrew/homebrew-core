class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.42.0.tar.gz"
  sha256 "fe34c155d993ca9c926da4374b4ce905dbb3b538973ca5374161541cc8be184d"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39db8421a4fe26628c8b7ef0f2a481722392aadaf844b7cd18c7c866fe6525ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70055dbd62097fc6fb4e51f28f5ff11e733f2c1bdc7747f8874d9bfc6ec53853"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9350acffb0d4d7d6da7f4d535935905f360e1abdaacc20922b85554ed3f4f2d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "12debe816e6effd0151bdfe249c367fb0330d5e1f995e56969d7761a8251d7cf"
    sha256 cellar: :any_skip_relocation, ventura:        "e85e6f135e8a3f58b10c6adaa6bc6556e6efa1fc774ba958875e52ed221218dc"
    sha256 cellar: :any_skip_relocation, monterey:       "f2467869c94f262a48eaa448bc3b7dd27c0382e758e7519da5b5eb71e9f5ef9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab3f10c789c1f0d69d723a444066141e23ccdf8f9bd21a4fe8ab144800a4b8f7"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
