class Kubeshark < Formula
  desc "API Traffic Analyzer providing real-time visibility into Kubernetes network"
  homepage "https://kubeshark.com"
  url "https://github.com/kubeshark/kubeshark/archive/refs/tags/v53.4.0.tar.gz"
  sha256 "cd1311df1ee5bb0da6a3b0ceb96b4553a50a3d830eb9fca3e09dbdadec214d22"
  license "Apache-2.0"
  head "https://github.com/kubeshark/kubeshark.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "568b47b6b22c5f03918ac03c726203807cf410b36880e5aecaa42afc0d8aff58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b661e644aca12f69a5ede60eaf55f106a289ae5454604737a093987888891ffc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfdaf6152ff45d0ed935c3e96965920c2162bf8713ba255ba1c39aef00774cd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "eed570dd1d0f97c8ffea452ffc5c94190e348ea989b71b17ad23dfcd959e942f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f14ec9e9141b4fe59adce36d3ecdc107cd8860e0bb877512da72a189427e791d"
    sha256 cellar: :any,                 x86_64_linux:  "a1a8f3dacd3a56f85ddc287c8f58ea97369e3e8c042a40f5304bf822abf8646b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X "github.com/kubeshark/kubeshark/misc.Platform=#{OS.kernel_name}_#{Hardware::CPU.arch}"
      -X "github.com/kubeshark/kubeshark/misc.BuildTimestamp=#{time}"
      -X "github.com/kubeshark/kubeshark/misc.Ver=v#{version}"
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeshark", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kubeshark version")
    assert_equal "v#{version}", version_output.strip

    tap_output = shell_output("#{bin}/kubeshark tap 2>&1")
    assert_match ".kube/config: no such file or directory", tap_output
  end
end
