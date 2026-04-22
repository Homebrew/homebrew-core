class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "92e7fe269dd537c341dd845b1ee162954031fe92dc9829ec3ee004a2572a2115"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36cefbcc7e5ab4f20f87f9f514a26faf51d69418ce1e2f8141c6c8b9515bb9fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e1335ad709081f28cc09a7c3db5ff52e540ab0313fa40d5147bf0f022a8b451"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47a594c57b1b1d149cb72cbbe713193808b4a31e07277a6b15e4e0af1cc851db"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee2a92647c60949c409b8531f1c8a3f44342a5693e4365a8510bd6228ec24d5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19aeaa6b4f63f993fdfc5ea89a0f8bacb83c6d9661b9e6333cfaec4e0e8627a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "952aad4b1c5c2944bc427d9436a10dab3c6aa20782213fdfd8f1591989a863d0"
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
