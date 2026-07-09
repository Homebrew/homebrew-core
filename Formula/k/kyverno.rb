class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "d8aefee8cc5dd5e127bb536e2fa4c42f20879f163026c05184499ddd3f44f88f"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b2132f688a5063d1a5975655784fd75583ff8e3a353ff0f731e4ba1c1c6ac89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fbb0658ac28b2b44f11aedaf10311f3e61b80621c23ed0b18ae92b09a0b1a2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c130c844084ebc34aedf22fda573a2a1fcc0ee34699344abe6d00b503fbc3f08"
    sha256 cellar: :any_skip_relocation, sonoma:        "39f6e0fc510e363b861518c0b8b466dd9d733eef50e6d6f594e15107fd5eae8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aac63239790675d05552e2be41887e1be2063c1ee4d051e01b3673a45088549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1ff80b8475a83188c72a3407746152f7f2090e78636cf36174ebd2f5fed7a4e"
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
