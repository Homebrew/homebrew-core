class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "e6661e8f2f2fbd547baec0af3836715a40adf5f999232d72947951b982e7daf7"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fd79bae583d821d1c544ee86ff3ca08c8fcdd527d6679afc1a97c9932810b03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "953b3d0653e25e06bb58434786ffc9e7ed2991c0578d0da120f75d1a14d29594"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb70f26d97ffc9698deb17da2cebcbeb7ee730ec5ee09a84c1b2b0dafe557956"
    sha256 cellar: :any_skip_relocation, sonoma:        "f157efa9d703915a49585a112f33c9dc10a4495799b867cdd238cd0071b5b6ae"
    sha256 cellar: :any_skip_relocation, ventura:       "f1308a91d03ef6c5237b0517a5984918e72d2cf22fa99b3b4a89c47b85e517b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "233d3372548328672739978736660ce743192289d0d05aa1fcca56401ed01344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cefd0aedf72054584bcbc66eb4674d0851c7c0730f14d6017809ff6c545f8141"
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
