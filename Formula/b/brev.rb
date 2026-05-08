class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.324.tar.gz"
  sha256 "6cf1e37bbd5687dce3f3d43c9c236384fbecfec371c79fb72a113cd872e386b8"
  license "MIT"
  head "https://github.com/brevdev/brev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2becc2d3114d8776670c1a4eb9ac9dcd84425f2be0658260a37523a113eec1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2becc2d3114d8776670c1a4eb9ac9dcd84425f2be0658260a37523a113eec1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2becc2d3114d8776670c1a4eb9ac9dcd84425f2be0658260a37523a113eec1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "61ec0d04779f075f2a6f0703daf070daa1c731b3869011d47362ef6e1223384d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aac99e4da19030aee352f8578d3b9db13c902206cbeaa19a429495916751580b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "304e6411a82bbe4607c4bf213b701e0bb90932aa14e564641ff1fb732955ba58"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", shell_parameter_format: :cobra)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
