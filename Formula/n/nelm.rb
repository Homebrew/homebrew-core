class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  # Check stable version at https://github.com/werf/nelm/blob/main/trdl_channels.yaml
  url "https://github.com/werf/nelm/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "b5a6e71cf5e936d0abb809ccf8daa5992976787b158bd7132c80e96c5b5a32c4"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # trdl_channels.yaml is used by official auto-updater to track latest version.
  # See https://werf.io/about/release_channels.html
  livecheck do
    url "https://raw.githubusercontent.com/werf/nelm/refs/heads/main/trdl_channels.yaml"
    strategy :yaml do |yaml|
      yaml["groups"]&.filter_map do |group|
        channel = group["channels"]&.find { |channel| channel["name"] == "stable" }
        channel&.[]("version")
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
    ldflags = %W[-X github.com/werf/nelm/v2/pkg/common.Version=#{version}]
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
