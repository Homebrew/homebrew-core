class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke.git",
      tag:      "v2.19.0",
      revision: "357aa44f5a04df9d1faa8c57bb5ce924871a910a"
  license "MIT"
  head "https://github.com/rebuy-de/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ef274877b43d3529e5aea1aba2f67f425f51998be0fad5f9ad0426817d72041"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ef274877b43d3529e5aea1aba2f67f425f51998be0fad5f9ad0426817d72041"
    sha256 cellar: :any_skip_relocation, monterey:       "afd65213fcc12219e471cf497d1dc985b91b31009b6e1166598e5e22386e649c"
    sha256 cellar: :any_skip_relocation, big_sur:        "afd65213fcc12219e471cf497d1dc985b91b31009b6e1166598e5e22386e649c"
    sha256 cellar: :any_skip_relocation, catalina:       "afd65213fcc12219e471cf497d1dc985b91b31009b6e1166598e5e22386e649c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f087c387e43dc35205c3e5c04e85ecb5aaf499c6106002bf94af6b057e45bbc3"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.com/rebuy-de/aws-nuke/v#{version.major}/cmd"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.BuildVersion=#{version}
      -X #{build_xdst}.BuildDate=#{time.strftime("%F")}
      -X #{build_xdst}.BuildHash=#{Utils.git_head}
      -X #{build_xdst}.BuildEnvironment=#{tap.user}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    pkgshare.install "config"

    (bash_completion/"aws-nuke").write Utils.safe_popen_read("#{bin}/aws-nuke", "completion", "bash")
    (fish_completion/"aws-nuke.fish").write Utils.safe_popen_read("#{bin}/aws-nuke", "completion", "fish")
    (zsh_completion/"_aws-nuke").write Utils.safe_popen_read("#{bin}/aws-nuke", "completion", "zsh")
  end

  test do
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke --config #{pkgshare}/config/example.yaml --access-key-id fake --secret-access-key fake 2>&1",
      255,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
