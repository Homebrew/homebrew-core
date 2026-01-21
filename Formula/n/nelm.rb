class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "11f84032ea4f2ea3a9fe85e92486a1c11dd6745052e2b57cfaaeabb8460f7823"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a02f7ee30e2f0a57f6a23dbde1cbce8153469e9c42e2f345c4911b2af418ca82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17acd87c094a31d3add10bcfd91bb04ee342fab9476d998923e1d51dd07a1cbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b3f72adc828cc678663da1ebad535667e155f671326d150eb838f65baf2ceb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e518451773e8e152c2890a9fedc6e99ced17b48ba7a9b9aaf2fa9d6178bd97eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01eb77f0597114a5f4ebb7043890f7832dd2a4652d3428e85c1c5822a386e7aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a81416af088af0083bfa4249b35048f6e02986deeee2e060b101939aa8ad2641"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/pkg/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nelm version")

    (testpath/"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https://127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}/nelm chart dependency download 2>&1", 1)
  end
end
