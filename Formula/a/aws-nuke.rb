class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.63.2.tar.gz"
  sha256 "003ad68131d39c916dd8ec2b84b854ffdc88c784199772294c4f1ccca526dfa3"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd254de7fa0a814b71907a17567e5800caec21ddb46a4a1a56d578e509d104ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd254de7fa0a814b71907a17567e5800caec21ddb46a4a1a56d578e509d104ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd254de7fa0a814b71907a17567e5800caec21ddb46a4a1a56d578e509d104ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "29ecff04082783644e036e05fc9cc398238445cd3abd165909104d17e2099796"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f264867fc8346a00d8facef76c3c132eb4a47e90eeb051d47937616197090c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0178ba562d9ad8490a30aa1ee12784d7f8f173c0fa055f77f4eb73aefc53477c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
