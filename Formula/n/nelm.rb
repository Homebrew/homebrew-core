class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "deb3878cbfd4889bba803cfe89ee34871b90ec4e283984972178344a7f43f514"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Upstream may indicate an unstable release by marking it as pre-release,
  # appending an unstable suffix to the tag (e.g. "v1.2.3-alpha.1"), or
  # appending unstable text to the release title (e.g. "v1.2.3 [alpha]").
  # Unstable versions are not always marked as pre-release, so we have to check
  # multiple releases to reliably identify stable versions.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        next if release["name"]&.match?(/(alpha|beta|dev|rc)/i)

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "149ccb985c378e0686ac67d555493eb2c16cec6d01723fcdc4baa85ede95e4a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc4e6521bd167c20078201423b75229abc3f023dca7d0975ca1afe6bcff38241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b35455b487bdabc4f9ff5c60bb3c239c3226d02e75d953ed5d8c054657f3393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "32d7ffd0a436067951f599298bd73bc20e0f8fc6f0d4d2d05ce626a0ba6b2517"
    sha256 cellar: :any_skip_relocation, sonoma:            "cc39f07dc47e0fe44fe148115f30598c791e92d4fb491b5b9b5e07366f2e4623"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47f4cca19316306b758c246ca3f757a00a6ec21899300f80ec50ea57ad92e0bb"
    sha256 cellar: :any,                 x86_64_linux:      "235773c8dab017a267bf354125538b44df88cf27ff9624dec930530004414542"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/werf/nelm/pkg/common.Version=#{version}]
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
