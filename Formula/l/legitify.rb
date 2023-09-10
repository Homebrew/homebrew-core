class Legitify < Formula
  desc "Tool to detect/remediate misconfig and security risks of GitHub/GitLab assets"
  homepage "https://legitify.dev/"
  url "https://github.com/Legit-Labs/legitify/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "9bc8ebfda06a82a8e1e08af14c0a22041c1d26dfd8e55189f9ed2326a13a42bc"
  license "Apache-2.0"
  head "https://github.com/Legit-Labs/legitify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe9eafe70dc4618c0b4c778137b95629a280f26e0e2cb358e9cdc24ec227b459"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5aea7a82d05e08baac98a0ef8927e2a0a26b56803a3ce70e3b8e0261aa4c4a61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf0dae439bb7060893189833a51382a620707fe6ce4a036e2e58bdb7108f1259"
    sha256 cellar: :any_skip_relocation, ventura:        "6838090a8d04faa346a702cef3edd90dc1d03069460d2654c657dffbb1044e8c"
    sha256 cellar: :any_skip_relocation, monterey:       "469ee9ccc399d85eeefd321ebf7c16ad95844865bd87ec6a5b6f93c5b4c1b4c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd49f19b1dfa07702dcae76fd3984a1c0c72fd61bffb844d1a582316c0593718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd1f048195ff66bd914c7e725f9b9dec11cea8f61f7da4853d2335dec8b3ebc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/Legit-Labs/legitify/internal/version.Version=#{version}
      -X github.com/Legit-Labs/legitify/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"legitify", "completion")
  end

  test do
    output = shell_output("#{bin}/legitify generate-docs")
    assert_match "policy_name: actions_can_approve_pull_requests", output
    assert_match version.to_s, shell_output("#{bin}/legitify version")
  end
end
