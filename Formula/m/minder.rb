class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "f44e49a639b742937a3b3841ef5d9ae9181858ef9f793608fb00bc95985e2d77"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7bf4422fc8e8f2b3623afa2e39a5197c3547b6a457d72ce7082aae7cd0b91c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f7754c33bdff1378a6df59344cc2e22585552934c3290192b9e3042255cda1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d1cd97ee7cc9895413feafcda0ae40e5dac528634c26b6d48b86b9d671fa45"
    sha256 cellar: :any_skip_relocation, sonoma:        "001f526a83bd9410023daf401d7bf3e34101032f6403fb7e98abf4c8baa2910c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d1ddaad318f5367e832935e616cbd1c7ddc367848b11c16f61935dc39895c54"
    sha256 cellar: :any,                 x86_64_linux:  "6f2e471d978f31f0f340b6551215de6e56e3aeedafaae5e08d059e9446a2f1c1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version 2>&1")

    # All the cli action trigger to open github authorization page,
    # so we cannot test them directly.
  end
end
