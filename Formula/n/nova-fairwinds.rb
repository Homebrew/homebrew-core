class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.9.tar.gz"
  sha256 "37610ae7bfa86e14a95e94de55f9833a3a269ac1d4f7a94bfc1fdbafa5277c29"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a50f817b266b08f8ef0a0fe6664efa6f1ec1b1a460f4034650322ab9902519ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a50f817b266b08f8ef0a0fe6664efa6f1ec1b1a460f4034650322ab9902519ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a50f817b266b08f8ef0a0fe6664efa6f1ec1b1a460f4034650322ab9902519ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b5bbe3cc2dd24ef49426adcbb5345d4b40a88e5e2174f54fffca6260757648a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "323cf8bf20c935d0effe3f5c23d090ce42ceffa132cea563984a08f4b5352e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "315e2a607efe32f6ad5bbc9ab227a84f8e1d4fa5dc6f3fea24e6adf7194b2dfd"
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
