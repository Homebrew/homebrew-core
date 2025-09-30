class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.8.tar.gz"
  sha256 "f0bb4c07f580a0c8f3661ef84d61554bd791b7a3bb49f612cb7a4183a5dbe061"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "027a219c228a63eb1b4ead35ef84d68bdb0270e0e80bde5eec80012b7215cadf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0307938adcbe20d13815700636303b9d9472f21a6b7b3988db8dba15dd96932d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0307938adcbe20d13815700636303b9d9472f21a6b7b3988db8dba15dd96932d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0307938adcbe20d13815700636303b9d9472f21a6b7b3988db8dba15dd96932d"
    sha256 cellar: :any_skip_relocation, sonoma:        "11f78c3a77156aa1e057d30e684cb39c1545173a48a45706ecdf28b356d8ee93"
    sha256 cellar: :any_skip_relocation, ventura:       "11f78c3a77156aa1e057d30e684cb39c1545173a48a45706ecdf28b356d8ee93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a73502a71157b399cd366debb4c8bf671fe4fe7c4ad20251677bba8f64f1636"
  end

  depends_on "go" => :build

  conflicts_with "open-simh", because: "both install `nova` binaries"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(output: bin/"nova", ldflags:)

    generate_completions_from_executable(bin/"nova", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nova version")

    system bin/"nova", "generate-config", "--config=nova.yaml"
    assert_match "chart-ignore-list: []", (testpath/"nova.yaml").read

    output = shell_output("#{bin}/nova find --helm 2>&1", 255)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
