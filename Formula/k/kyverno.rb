class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "7aa0f69bcb70be996139d26e224ed3dece284efe980c549eb611e80458b4483b"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bb503d7051addc072c642b780f7f5d04c4748fe3932952717b266197968a32b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a8bc9dc1e0a48f4223ec8d7459503b11414dcdb56fbeca26c730dc8ce98fcad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f523fa8ac6e5f30fd652b21e31c75d3237121ceff618b0977bbe87abf0ca2aab"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f9607ddb440d63ff7014bf1deb500e69b9aadf9a44f10c3fb6eb326f71db819"
    sha256 cellar: :any_skip_relocation, ventura:        "904fc68b9c97bf58afb3a1c2532eab80817201a642ebabfbf059db9740bdc552"
    sha256 cellar: :any_skip_relocation, monterey:       "471571b5c0733b69bc8823a5882f9f62faea6d5c7a3c68e08d8ae2a7c0ef8b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdd730a645888e79b2c57a81e66e8985e1f7c6229d31a782c5fabd2e249e374c"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end
