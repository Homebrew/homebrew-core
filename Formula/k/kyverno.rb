class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "05afa6e889d360d37da5f3a4fd3c845492ed1879127cbaf54886ea735fec4cb4"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca53a9429325958eeed9864cb520d8a284b757298e768f038c991a1895ed5db7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e669128114fc92c20c0fdda9a72af7679f80424072b15f141323cd3a73e3298a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c097d7ddd4b59d1b15b672ab5af7d8cce487d92542333f9d0f896bcc0a3b6d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1890ae533957dedf6d26f7b356cbd6d1ece7c4e7b4f5ffd6110d9c084214ce1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09212105ef7ee0a08a53fe600f67c2671c06073995c15d6237bae3dc01bdae01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "579a5981ef6d90ad4f2c4ae0dddcab8c4494d150ce82009b96ab2e90fe6e9217"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", shell_parameter_format: :cobra)
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end
