class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "4597e2c616287a1e4de66feddd73ac5feb7b9e89e756482c646c4d1e8c959c86"
  license "GPL-3.0-only"
  head "https://github.com/contabo/cntb.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ab5dfa20bc572faa11be29a57a5e472dc1a0f29210026f8558ae8ff1ec98826"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ab5dfa20bc572faa11be29a57a5e472dc1a0f29210026f8558ae8ff1ec98826"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ab5dfa20bc572faa11be29a57a5e472dc1a0f29210026f8558ae8ff1ec98826"
    sha256 cellar: :any_skip_relocation, sonoma:        "f001fb06386d6ac1e9aa152be2aac1fbc40cd0b7fe9094f8d5537284021087a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3a05bb063c99325120981ba2e1bf55daba26fc46d9e58b9996ca55144b5fff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b727f7c5bb9baf5aa06f27f07940d1bae368edbdeb7174df834de6ff48fc953"
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
