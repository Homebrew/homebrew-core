class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.331.tar.gz"
  sha256 "4d1f7a695b78876e71261156ddd4713dc95c2c56a49bff450d9b1507a894b483"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73590113e203d51a36cc330c273c304bef8686fe2fc0cd6541909708748abe01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73590113e203d51a36cc330c273c304bef8686fe2fc0cd6541909708748abe01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73590113e203d51a36cc330c273c304bef8686fe2fc0cd6541909708748abe01"
    sha256 cellar: :any_skip_relocation, sonoma:        "33d5d46d25b2fc51e1b9c0c840d3be4cd6a8119f77b14b2843f63157a12f8c98"
    sha256 cellar: :any,                 arm64_linux:   "7004f6268659008aaf2f8f96caf198fcb4680606db8c143ca0daaf2b71071d02"
    sha256 cellar: :any,                 x86_64_linux:  "e8d590a6ccc34e9aab002a320ac5f929644dbebcf646cf4e379c20e5b1bc00a1"
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
