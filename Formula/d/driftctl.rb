class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.39.0.tar.gz"
  sha256 "384e9d675881546b635e0864a88139f02bae0602f0e2a935c84856840c5bba83"
  license "Apache-2.0"
  head "https://github.com/snyk/driftctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89a9e5e3de6017f4f0989651dfec73a452b412f2203df1cf99bb09e19391dbc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bd0ef3cf76e7168310eaf9d4cfa8154d0cfc32e107feda9288b3ca18c26e76c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bd0ef3cf76e7168310eaf9d4cfa8154d0cfc32e107feda9288b3ca18c26e76c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bd0ef3cf76e7168310eaf9d4cfa8154d0cfc32e107feda9288b3ca18c26e76c"
    sha256 cellar: :any_skip_relocation, sonoma:         "311c08c4b576e80fb5a241fc8e64bc6a4ce8872e0167aecc467a807a86cb8c90"
    sha256 cellar: :any_skip_relocation, ventura:        "4867ada6616e2cc615ed4cd5918cd6c17797829aa8abe2ef7e204468b64e536d"
    sha256 cellar: :any_skip_relocation, monterey:       "4867ada6616e2cc615ed4cd5918cd6c17797829aa8abe2ef7e204468b64e536d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4867ada6616e2cc615ed4cd5918cd6c17797829aa8abe2ef7e204468b64e536d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0044e27f2515c0d9f13764be7ff0b4eb0fb15be2a503030c23ade51c7db9a130"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/snyk/driftctl/build.env=release
      -X github.com/snyk/driftctl/pkg/version.version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"driftctl", "completion")
  end

  test do
    assert_match "Could not find a way to authenticate on AWS!",
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}/driftctl version")
  end
end
