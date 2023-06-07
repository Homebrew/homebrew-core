class LicenseEye < Formula
  desc "Tool to check and fix license headers and resolve dependency licenses"
  homepage "https://github.com/apache/skywalking-eyes"
  url "https://github.com/apache/skywalking-eyes/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "9a8f9dc34772a1357dc4c578b065f07e1492230b7d767f91bffa5fd212c9a258"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-eyes.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcb1c4e71c6ba8f95cd8e5a3575203a23aa902c75ad54d09e609cd92223ee471"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b529d2b2a6acd07e456679165c835f6746831461c01091b734cdf078739fcc0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "817bb92ef9bedf40930575884c6a3cb56f60b58e30883dff98e5567e9020a3a8"
    sha256 cellar: :any_skip_relocation, ventura:        "15be89303dc6e43bcefb640562fa2ad3c4b2e621e3ad9766ed52471f7b921016"
    sha256 cellar: :any_skip_relocation, monterey:       "987285c263d671d34283c78f7bbc8a59f07cad99d042afa38dc63921c02f0b08"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1e8fc941f02819d1290f6dad173561c0640d579173f52b77001e1f4a18f4f40"
    sha256 cellar: :any_skip_relocation, catalina:       "be68a423bcecb7cb02498285af32a9a4d1381fcd62978d0f2aa22d5aa8bdec4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad8dddc59e2730c36de89b1a9600143ea56e4fd336c29b2cd0b0d64f08b31391"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/apache/skywalking-eyes/commands.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/license-eye"

    generate_completions_from_executable(bin/"license-eye", "completion")
  end

  test do
    output = shell_output("#{bin}/license-eye dependency check")
    assert_match "Loading configuration from file: .licenserc.yaml", output
    assert_match "Config file .licenserc.yaml does not exist, using the default config", output

    assert_match version.to_s, shell_output("#{bin}/license-eye --version")
  end
end
