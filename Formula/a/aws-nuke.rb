class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.64.1.tar.gz"
  sha256 "23c28fd84afdf16eb69725055dce59cb1581d0ba38e07c5ba6bbd431e0b98ba9"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6784837f24c15cd38dcbeb29b4701fc5815ea344b2911872623028c417fb1007"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6784837f24c15cd38dcbeb29b4701fc5815ea344b2911872623028c417fb1007"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6784837f24c15cd38dcbeb29b4701fc5815ea344b2911872623028c417fb1007"
    sha256 cellar: :any_skip_relocation, sonoma:        "09c58faaff36f92470c5bffbc0ac720ec67a982fbe9d44293e978f8378c4315e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "758a800a0ec1d7dbd058a3b37de7aabbefe885485c90746aa2e2d710441348d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a3ed7053a33da0e671133aa32e506b158efa513c9fe30ba859722412df92b24"
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
