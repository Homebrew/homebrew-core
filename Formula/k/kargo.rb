class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "097394d7d8a1d348d4ed9a4d9da1cc7cb7ae52aacdcfa75ce6c19ba85cdd9df8"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92f227c0a233d356385a190323a0c92715b31049122c7b714548cb4594b73aac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d9e261625dc7c15e401156b6c21a8b5c0b7238800b22782d9003e4c44cd211d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28114366b729670904ae6a0cfa9bfc7f8b88a681ee51692c03d9f1dd71d857b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f6bf2c4456c1c19e90c4cb0f16752778c8d19ebcdcecc51bb0b4a375c28920e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45eb7288b0c7c06d6583996f6d5417c5c3b564164cf1cb3654211f811aee7033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab56bff3885ff7a9343cf88e915b4a35e2adf82ef68b8ffe5b01e9e09d41bf5b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
