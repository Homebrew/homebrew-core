class Legitify < Formula
  desc "Tool to detect/remediate misconfig and security risks of GitHub/GitLab assets"
  homepage "https://legitify.dev/"
  url "https://github.com/Legit-Labs/legitify/archive/refs/tags/v1.0.11.tar.gz"
  sha256 "f63809a93571a72269aed6c10fa3cb1a0f384802857c21740386773690b696bb"
  license "Apache-2.0"
  head "https://github.com/Legit-Labs/legitify.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ad85e946db932a1562a409f65349e4bbea50e7775e5c053cad0e214362fe9be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ad85e946db932a1562a409f65349e4bbea50e7775e5c053cad0e214362fe9be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ad85e946db932a1562a409f65349e4bbea50e7775e5c053cad0e214362fe9be"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fe85676589c8defc67ba6c2f7ddb83c7386b7c5d86147ca170238e5fd18707c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd5c133ed0e35b7d07656bc9f290ed83149c1c45077f3aa20275890916bb1f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "467b678a47f512a636ab25c2d14106c7371b2917670c0fa01fb7f51d6796b006"
  end

  # no release since 2024-07-09, fails with go 1.25+ https://github.com/Legit-Labs/legitify/pull/350
  deprecate! date: "2026-01-15", because: :unmaintained

  depends_on "go@1.24" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Legit-Labs/legitify/internal/version.Version=#{version}
      -X github.com/Legit-Labs/legitify/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"legitify", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/legitify generate-docs")
    assert_match "policy_name: actions_can_approve_pull_requests", output
    assert_match version.to_s, shell_output("#{bin}/legitify version")
  end
end
