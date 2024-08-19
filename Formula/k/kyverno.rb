class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.12.5.tar.gz"
  sha256 "0b54ca0e275ba66fe49cc5c5caf3d1a08cf0dbf1161c1f80d014508b4a5abac1"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fe6de5c144eb0636963339f346c730c347d50b94863b9e09f90f802615a670d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "861066d6bdc69a0f3c853f554a53047dff9c6396fc90b4bb8989c9b46df4c8ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5df552ca39863c682cdd2676a199ef290dbb873d1f0085cd36208466c78fd5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a46fbe210d598ed92edf8f795eb2621f336d91db12f7ee39ea08c1a0a596a26c"
    sha256 cellar: :any_skip_relocation, ventura:        "bcb9f99d5671ed1b7c2030730de52a8a090963aba256434ddacdff6496dd7b92"
    sha256 cellar: :any_skip_relocation, monterey:       "5e3a2835a0c6587dce94a454604edbdd5ff00d87980e71e4dfcd94cc32bdeab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c351380721bb8e2d7ce10666b440398f13bb643adafd5270e753a4d96c0cc59"
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

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end
