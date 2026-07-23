class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/v1.7.tar.gz"
  sha256 "bd8f1aa809496b69ec86c60dfd1b1aacf511a7f286d3f15c012561aae0e89b82"
  license "GPL-3.0-only"
  head "https://github.com/contabo/cntb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbf45b52bdbb2a80706caeef375bf6e6cac182fded30afa9d2185e7e4f08cb62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbf45b52bdbb2a80706caeef375bf6e6cac182fded30afa9d2185e7e4f08cb62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbf45b52bdbb2a80706caeef375bf6e6cac182fded30afa9d2185e7e4f08cb62"
    sha256 cellar: :any_skip_relocation, sonoma:        "1afa303aee48e7714da700ecde5db5e81b9ca1a86e5948e5c5e200143d196414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7745c696b2588c06d07a7a54bf6dc00ab80db307fabd7dcf316cbeb4c5b5e8be"
    sha256 cellar: :any,                 x86_64_linux:  "36c0d68cfc3085230338ee2a35408a326c5f86b5516b33947ac7eb1e25688783"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.com/cli/cntb/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cntb", shell_parameter_format: :cobra)
  end

  test do
    # version command should work
    assert_match "cntb #{version}", shell_output("#{bin}/cntb version")
    # authentication shouldn't work with invalid credentials
    out = shell_output("#{bin}/cntb get instances --oauth2-user=invalid \
    --oauth2-password=invalid --oauth2-clientid=invalid \
    --oauth2-client-secret=invalid \
    --oauth2-tokenurl=https://example.com 2>&1", 1)
    assert_match 'level=fatal msg="Could not get access token due to an error', out
  end
end
