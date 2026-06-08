class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/v1.6.tar.gz"
  sha256 "70ba41e521283574f46afa8a1e4a9ee6244fa641568c24b5414304f2fc4c89f7"
  license "GPL-3.0-only"
  head "https://github.com/contabo/cntb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aab7b4107c3bbf83ed83496409641d6e24042ede466bed096e77626bad3b9287"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aab7b4107c3bbf83ed83496409641d6e24042ede466bed096e77626bad3b9287"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aab7b4107c3bbf83ed83496409641d6e24042ede466bed096e77626bad3b9287"
    sha256 cellar: :any_skip_relocation, sonoma:        "6af27760b6a17b17718f8f9d3fc63ab635c5406a3aa6c64637b2dd1867e9d9ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33757577830b8e59c9c23297b255c542140245fa2a388339a692c90b238c1b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "480eb7831df079625173f7bf3ac52a40808f6e93514be3771a4ae16a822ed411"
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
