class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "50e95c4e1bb0a9b939664a1def37f83509ee2f953c5bd70e7fca10e6470f8c11"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a958d53f93231ab9ff709af28496a69f3eff61f6fd933b4b18128168af8eefe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c52725838e7d8d342aff25ad197f039742d6f8d96150b0e21a53454291c59a98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd9a1ca4ecdc2a0f873c1d9c2ceb793f01c30445bc12e637b1cd6eec15566675"
    sha256 cellar: :any_skip_relocation, ventura:        "44e8a61433bbd2a174c01910495edac7b12bee83389218efa47c989f942b23b9"
    sha256 cellar: :any_skip_relocation, monterey:       "9bb8ac8902aa12ad49a0ac13ed52308057bb72e310f450ddc98217bf5683830b"
    sha256 cellar: :any_skip_relocation, big_sur:        "55ab5d47d669935f30e2df6e540b14f95a14760d1e2f9e27ec8f53d7cba47ccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b3bdc1e3ea8bbd86657eb79cf8c4a4ee08ab041bf4e753b2dc72d7dbe3792a2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end
