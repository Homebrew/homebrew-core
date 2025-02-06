class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.47.1.tar.gz"
  sha256 "6d8a29a9ac64a15d91ca30addda8f5053234415316214328a5858899bf924ec5"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9581dcdc8a9f00ea19dc9acc9cf7f26ba5ad6d52eb4023d903accee5b3c4e1c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9581dcdc8a9f00ea19dc9acc9cf7f26ba5ad6d52eb4023d903accee5b3c4e1c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9581dcdc8a9f00ea19dc9acc9cf7f26ba5ad6d52eb4023d903accee5b3c4e1c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "681e071c701b63431d50976205cc560fb1522401867e9d16587de4923cb8fae0"
    sha256 cellar: :any_skip_relocation, ventura:       "681e071c701b63431d50976205cc560fb1522401867e9d16587de4923cb8fae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b98fa3714f0f079427300b8591b5efdab15a7bedc1e00e9475ca791a5dd3301"
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

    generate_completions_from_executable(bin/"aws-nuke", "completion")
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
