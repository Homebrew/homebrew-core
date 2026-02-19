class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "2daecc7a99ea5d10cc6b0a3456073a7cbc9f23fd189891521d92b437761d22d8"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "421c2e4e925bded6d0100618b339cd50dd4db29f3242b6f61c7da47a280e9665"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "023d7a440cbdc366d27da5784885105850fc3a4493f913f0a7fe3d1d9cc64135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "719c7dfc668030afff8292cfff9e8bfa9415d6dde1215e8d05108a48b026cda6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c4a3cf7d907afb7e750b1d6edbf045bd784881881508a2cc277c8d434a7d48d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fc1eeb5fb4cbc24acb39f75c0311652064470cbc800365b7c66deebd28537c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "242e213704fb5d560993a30c196c651b1ca7efb11ed598ed7bcd719c02e6179c"
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
