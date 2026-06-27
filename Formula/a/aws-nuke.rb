class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://aws-nuke.ekristen.dev"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.65.0.tar.gz"
  sha256 "feb73b963ef14fe8fb1a3b77ad274e497edf41479a8f5d02155d0144de5625e1"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "165dd1331b06091b280a4faff40a6da779454466c784e6fc80d9ffe3064cadff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "165dd1331b06091b280a4faff40a6da779454466c784e6fc80d9ffe3064cadff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "165dd1331b06091b280a4faff40a6da779454466c784e6fc80d9ffe3064cadff"
    sha256 cellar: :any_skip_relocation, sonoma:        "f44f9b0958b16077703f3a0dc9689bbc8bd3cf1e9dbae796353f95d6d75b6d31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bcb58a81eaf31415bcecdf765cd47dab4cbfa15bbcf416ce266b7663af55e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ebe05fbdb87057ac46bef588cf6bd003d52b1d94b9f4a72c4baaba14fc8d50"
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
