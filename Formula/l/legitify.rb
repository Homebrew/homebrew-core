class Legitify < Formula
  desc "Tool to detect/remediate misconfig and security risks of GitHub/GitLab assets"
  homepage "https://legitify.dev/"
  url "https://github.com/Legit-Labs/legitify/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "79cc2a8f3e2917e303e2b995d2da687ea614c09d2acf5e759bde9d657be4ba9c"
  license "Apache-2.0"
  head "https://github.com/Legit-Labs/legitify.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64b1e5a36e20f30ff13c6a5a9bf35fb65c8ed21d162f80191d04cf6b8bc10b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b689a7e4b49f3b99bcd6c155506e418a62966c10d6badc7ce4f55aebd2c93966"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f77208184ac09a5edf7e6200eee394aa7e27d539cb573a5b7c3538af87113082"
    sha256 cellar: :any_skip_relocation, sonoma:         "a563cdfd202c5d595d211c897c9b6d0e1a5f638afc1fd5a36c65066b814d7b31"
    sha256 cellar: :any_skip_relocation, ventura:        "3fba385a5322714acffa6738f457de02fcde005050a7f970d66b513b7b6b3714"
    sha256 cellar: :any_skip_relocation, monterey:       "0ec1895201f8dfb7a31b6f505b27bc36693670d501c96f1df7592c742b359f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69bcdcad8398d70cea2e2778b55834768fd5df33f5c47659ee74f2dcb632af67"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Legit-Labs/legitify/internal/version.Version=#{version}
      -X github.com/Legit-Labs/legitify/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"legitify", "completion")
  end

  test do
    output = shell_output("#{bin}/legitify generate-docs")
    assert_match "policy_name: actions_can_approve_pull_requests", output
    assert_match version.to_s, shell_output("#{bin}/legitify version")
  end
end
