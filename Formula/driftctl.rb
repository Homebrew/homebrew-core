class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.38.2.tar.gz"
  sha256 "c78b61495ae0b21cbca8a313fb23c2a76dd297fc8873286e92c5134cdb8d9276"
  license "Apache-2.0"
  head "https://github.com/snyk/driftctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b10f794fdbb5d7074869e8f561677556ad78cc08c4c7f936ecd37d24de671d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2b86da9b9c6973d7a2e0c4cd81289f5272a466d81987e4c1b48d5c695355fa6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "762272e3dd567d9aa7859bcd030c3300fdefbc54366a7427bf75796aebfbfa87"
    sha256 cellar: :any_skip_relocation, ventura:        "22aec4680ca6547d9e9a100c5194f992e4bd477508eb7b40ee7859b2f09359b7"
    sha256 cellar: :any_skip_relocation, monterey:       "8b7437f9e1c359aadfebcb1b5a52a26b7f387553c97403030051f5ceb6815e7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7a3a03626d617abd1132d079c1e2498785728d1f3e7a8894449ce8178a2485b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36e9c60b03beda8a6e90ff2139e3d26ffefeb689d0dd7e28f030c4e8ad331ac4"
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
